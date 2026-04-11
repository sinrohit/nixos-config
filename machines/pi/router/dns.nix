let
  localServices = [
    "vault"
    "immich"
    "nextcloud"
    "git"
    "s3"
  ];
in
{
  ############################################################
  # DNS (unbound + adguardHome) on LAN
  ############################################################

  imports = [ ./adguard.nix ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "::1"
        ];
        port = 5335; # AdGuard will forward here
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
        # Only allow queries from LAN and loopback
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
          "10.0.0.0/24 allow"
          "100.64.0.0/10 allow" # Tailscale CGNAT range.
        ];
        local-data = map (s: "\"${s}.sinrohit.com. A 10.0.0.10\"") localServices;
      };
    };
  };
}
