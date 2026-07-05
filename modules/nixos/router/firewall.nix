{ config, lib, ... }:

let
  cfg = config.homelab.router.firewall;
  netCfg = config.homelab.router.network;
in
{
  options.homelab.router.firewall = {
    enable = lib.mkEnableOption "nftables firewall and NAT";

    trustedInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "lo"
        "tailscale0"
      ];
      description = "Interfaces that are fully trusted (inbound accepted)";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nftables = {
      enable = true;
      flushRuleset = false;

      tables = {
        nat = {
          family = "ip";
          content =
            let
              wan = if netCfg.enable then netCfg.wan.interface else "wan0";
              lan = if netCfg.enable then netCfg.lan.interface else "lan0";
            in
            ''
              chain prerouting {
                type nat hook prerouting priority filter; policy accept;

                # Exempt comet - it has its own resolver
                ip saddr 10.0.0.170 return

                # Force all LAN DNS through Unbound/AdGuard
                iifname "${lan}" udp dport 53 counter redirect to 53
                iifname "${lan}" tcp dport 53 counter redirect to 53
              }
              chain postrouting {
                type nat hook postrouting priority 100; policy accept;
                oifname "${wan}" masquerade
              }
            '';
        };

        global = {
          family = "inet";
          content =
            let
              wan = if netCfg.enable then netCfg.wan.interface else "wan0";
              lan = if netCfg.enable then netCfg.lan.interface else "lan0";
              # Build the iifname vmap from trusted interfaces + lan, dropping wan
              trustedMap = lib.concatMapStringsSep ", " (i: "${i} : accept") ([ lan ] ++ cfg.trustedInterfaces);
            in
            ''
              chain inbound {
                type filter hook input priority 0; policy drop;
                ct state vmap { established : accept, related : accept, invalid : drop }
                iifname vmap { ${trustedMap}, ${wan} : drop }
              }
              chain forward {
                type filter hook forward priority 0; policy drop;
                ct state vmap { established : accept, related : accept, invalid : drop }
                iifname "${lan}" oifname "${wan}" accept
                iifname "tailscale0" accept
              }
            '';
        };
      };
    };
  };
}
