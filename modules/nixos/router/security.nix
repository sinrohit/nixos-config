{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.router.security;
in
{
  options.homelab.router.security = {
    enable = lib.mkEnableOption "router security hardening";

    fail2ban = {
      maxretry = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "Max failed attempts before banning";
      };
      bantime = lib.mkOption {
        type = lib.types.str;
        default = "3600";
        description = "Ban duration in seconds";
      };
    };

    disableIPv6 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Disable IPv6 via sysctl (router doesn't support IPv6 yet)";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      useDHCP = false;
      enableIPv6 = !cfg.disableIPv6;
      wireless.enable = false;
      firewall.enable = false; # replaced by homelab.router.firewall (nftables)
      nat.enable = false;
    };

    services = {
      fail2ban = {
        enable = true;
        inherit (cfg.fail2ban) maxretry bantime;
        jails.sshd.settings = {
          enabled = true;
          filter = "sshd";
          action = "nftables-allports";
        };
      };

      journald.extraConfig = ''
        SystemMaxUse=500M
        MaxRetentionSec=7day
      '';

      timesyncd.enable = true;
    };

    security = {
      protectKernelImage = true;
      allowUserNamespaces = true;
      unprivilegedUsernsClone = false;
      audit.enable = true;
      auditd.enable = true;
    };

    boot = {
      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;

        "net.ipv6.conf.all.disable_ipv6" = lib.mkIf cfg.disableIPv6 1;
        "net.ipv6.conf.default.disable_ipv6" = lib.mkIf cfg.disableIPv6 1;

        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
        "kernel.printk" = "3 3 3 3";
        "kernel.unprivileged_bpf_disabled" = 1;
        "net.core.bpf_jit_harden" = 2;

        "net.ipv4.tcp_max_syn_backlog" = 2048;
        "net.ipv4.tcp_synack_retries" = 2;
        "net.ipv4.tcp_syn_retries" = 5;
        "net.ipv4.tcp_rfc1337" = 1;

        "net.ipv4.conf.all.log_martians" = 1;
        "net.ipv4.conf.default.log_martians" = 1;
      };

      tmp.cleanOnBoot = true;
    };

    systemd.coredump.enable = false;

    environment.systemPackages = [
      (pkgs.writeScriptBin "router-security-check" ''
        #!${pkgs.bash}/bin/bash
        echo "=== Router Security Status ==="
        echo ""
        echo "Firewall Status:"
        ${pkgs.systemd}/bin/systemctl status nftables.service | ${pkgs.gnugrep}/bin/grep -E "(Active|Loaded)"
        echo ""
        echo "SSH Status:"
        ${pkgs.systemd}/bin/systemctl status sshd.service | ${pkgs.gnugrep}/bin/grep -E "(Active|Loaded)"
        echo ""
        echo "Active Connections:"
        ${pkgs.nettools}/bin/netstat -tn | ${pkgs.gnugrep}/bin/grep ESTABLISHED | wc -l
        echo ""
        echo "Recent SSH Attempts:"
        ${pkgs.systemd}/bin/journalctl -u sshd.service --since "1 hour ago" | ${pkgs.gnugrep}/bin/grep -i "failed\|accepted" | tail -10
        echo ""
        echo "fail2ban Status:"
        ${pkgs.fail2ban}/bin/fail2ban-client status sshd 2>/dev/null || echo "No bans"
        echo ""
      '')
    ]
    ++ (with pkgs; [
      vim
      htop
      tcpdump
      ethtool
      conntrack-tools
      dig
      inetutils
      dnsutils
      nmap
      iptables
      nftables
    ]);
  };
}
