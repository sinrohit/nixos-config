{ pkgs, ... }:
let
  # Build-time ad-block list: fetches StevenBlack hosts and converts to
  # Unbound "local-zone: refuse" directives. No runtime network dependency.
  adblockLocalZones = pkgs.stdenv.mkDerivation {
    name = "adblock";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/sinrohit/hosts/master/hosts";
      sha256 = "sha256-YEhAlRxQWxVZ/VSJrCQscNXo6zFeJE8UgrqyNUTuKAA=";
    };
    dontUnpack = true;
    buildPhase = ''
      cat $src \
        | ${pkgs.gawk}/bin/awk '
            {sub(/\r$/,"")}
            {sub(/^127\.0\.0\.1/,"0.0.0.0")}
            BEGIN { OFS = "" }
            NF == 2 && $1 == "0.0.0.0" {
              print "local-zone: \"", $2, "\" refuse"
            }' \
        | tr '[:upper:]' '[:lower:]' \
        | sort -u > zones
    '';
    installPhase = ''
      mv zones $out
    '';
  };
in
{

  # Stable interface names by MAC address
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:e0:4c:2e:54:50", NAME="wan0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:3a:dd:aa:90:7f", NAME="lan0"
  '';

  networking = {
    useDHCP = false;
    enableIPv6 = true;
    wireless.enable = false;
    firewall.enable = false;
    nat.enable = false;

    nftables = {
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
  };

  # ── Router: systemd-networkd ──────────────────────────────────────────
  systemd.network = {
    enable = true;
    networks = {
      # WAN — DHCP client facing ISP / upstream router
      "10-wan0" = {
        matchConfig.Name = "wan0";
        networkConfig = {
          DHCP = "ipv4";
          IPv4Forwarding = true;
          DNS = "127.0.0.1";
        };
        dhcpV4Config = {
          UseDNS = false;
          UseNTP = false;
          UseHostname = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      # LAN — static IP, built-in DHCP server
      "20-lan0" = {
        matchConfig.Name = "lan0";
        networkConfig = {
          Address = "10.0.0.1/24";
          IPv4Forwarding = true;
          DHCPServer = true;
          DNS = "10.0.0.1";
        };
        dhcpServerConfig = {
          EmitRouter = true;
          EmitDNS = true;
          DNS = "10.0.0.1";
          EmitNTP = true;
          NTP = "10.0.0.1";
          PoolOffset = 100; # Dynamic range starts at .100
          PoolSize = 100; # .100 through .199
          ServerAddress = "10.0.0.1/24";
          DefaultLeaseTimeSec = 3600;
        };
        dhcpServerStaticLeases = [
          # Static leases for your devices go here:
          {
            MACAddress = "b8:85:84:9a:5d:12";
            Address = "10.0.0.10";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  # ── DNS: Unbound recursive resolver with ad-blocking ────────────────
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [
          "10.0.0.1"
          "127.0.0.1"
          "::1"
          "100.102.29.63" # TODO:: Find a better way
        ];
        port = 53;
        do-ip4 = true;
        do-ip6 = true;
        do-udp = true;
        do-tcp = true;
        prefer-ip6 = false;
        edns-buffer-size = 1232;
        prefetch = true;
        num-threads = 2;
        so-rcvbuf = "1m";
        qname-minimisation = true;
        # Ad-blocking: refuse queries for known ad/tracker domains
        include = toString adblockLocalZones;
        # Only allow queries from LAN and loopback
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "10.0.0.0/24 allow"
          "100.64.0.0/10 allow" # Tailscale CGNAT range. TODO: Find a better way
        ];
      };
    };
  };
}
