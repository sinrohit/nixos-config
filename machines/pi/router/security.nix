{ pkgs, ... }:
{
  networking = {
    useDHCP = false;
    enableIPv6 = true;
    wireless.enable = false;
    firewall.enable = false;
    nat.enable = false;
  };

  services = {
    fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "3600";

      jails = {
        sshd.settings = {
          enabled = true;
          filter = "sshd";
          action = "nftables-allports";
        };
      };
    };

    # Logging configuration for routers
    journald.extraConfig = ''
      SystemMaxUse=500M
      MaxRetentionSec=7day
    '';

    # NTP for accurate time sync (important for security logging)
    timesyncd.enable = true;
  };

  # System security hardening
  security = {
    # Protect kernel modules
    protectKernelImage = true;

    # Restrict ptrace
    allowUserNamespaces = true;
    unprivilegedUsernsClone = false;

    # Enable audit
    audit.enable = true;
    auditd.enable = true;
  };

  # Additional kernel hardening
  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;

      # Disable IPv6 (router core doesn't support IPv6 yet)
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;

      # Additional security
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;

      # Protect against SYN flood
      "net.ipv4.tcp_max_syn_backlog" = 2048;
      "net.ipv4.tcp_synack_retries" = 2;
      "net.ipv4.tcp_syn_retries" = 5;

      # Protect against time-wait assassination
      "net.ipv4.tcp_rfc1337" = 1;

      # Log martian packets
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;
    };

    # Clean temporary files
    tmp.cleanOnBoot = true;
  };

  # Disable coredumps
  systemd.coredump.enable = false;

  # Create security monitoring script
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
    # Essential tools
    vim
    htop
    tcpdump
    ethtool
    conntrack-tools

    # Network diagnostics
    dig
    inetutils
    dnsutils
    nmap

    # Security tools
    iptables
    nftables
  ]);
}
