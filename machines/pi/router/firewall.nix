{
  ############################################################
  # Firewall + NAT (nftables)
  ############################################################

  networking.nftables = {
    enable = true;
    flushRuleset = false;
    tables = {
      nat = {
        family = "ip";
        content = ''
          chain prerouting {
            type nat hook prerouting priority filter; policy accept;
            # Force all LAN DNS through Unbound
            iifname "lan0" udp dport 53 counter redirect to 53
            iifname "lan0" tcp dport 53 counter redirect to 53
          }
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "wan0" masquerade
          }
        '';
      };
      global = {
        family = "inet";
        content = ''
          chain inbound {
            type filter hook input priority 0; policy drop;
            ct state vmap { established : accept, related : accept, invalid : drop }
            iifname vmap { lo : accept, lan0 : accept, tailscale0 : accept, wan0 : drop }
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
            ct state vmap { established : accept, related : accept, invalid : drop }
            iifname "lan0" oifname "wan0" accept
            iifname "tailscale0" accept
          }
        '';
      };
    };
  };
}
