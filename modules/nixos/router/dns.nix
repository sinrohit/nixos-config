{ config, lib, ... }:

let
  cfg = config.homelab.router.dns;
in
{
  options.homelab.router.dns = {
    enable = lib.mkEnableOption "local DNS stack (Unbound + AdGuard Home)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "sinrohit.com";
      description = "Domain used for local DNS overrides";
    };

    lanAddress = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.10";
      description = "IP address local service hostnames resolve to";
    };

    localServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "vault"
        "immich"
        "nextcloud"
        "git"
        "s3"
      ];
      description = "Subdomains to resolve locally to lanAddress";
    };

    unboundPort = lib.mkOption {
      type = lib.types.port;
      default = 5335;
      description = "Port Unbound listens on (AdGuard forwards here)";
    };

    allowedRanges = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "127.0.0.0/8 allow"
        "::1 allow"
        "10.0.0.0/24 allow"
        "100.64.0.0/10 allow" # Tailscale CGNAT
      ];
      description = "Access control ranges for Unbound";
    };
  };

  config = lib.mkIf cfg.enable {
    services.resolved.enable = false;

    # Pull in AdGuard, pointed at our Unbound instance
    homelab.router.adguard = {
      enable = true;
      upstreamDns = [ "127.0.0.1:${toString cfg.unboundPort}" ];
    };

    services.unbound = {
      enable = true;
      settings.server = {
        interface = [
          "127.0.0.1"
          "::1"
        ];
        port = cfg.unboundPort;
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
        access-control = cfg.allowedRanges;
        local-data = map (s: "\"${s}.${cfg.domain}. A ${cfg.lanAddress}\"") cfg.localServices;
      };
    };
  };
}
