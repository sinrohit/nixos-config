{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.caddy;
in
{
  options.homelab.caddy = {
    enable = lib.mkEnableOption "Caddy reverse proxy for homelab services";

    email = lib.mkOption {
      type = lib.types.str;
      default = "rsrohitsingh682@gmail.com";
      description = "Email for ACME registration";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "sinrohit.com";
      description = "Root domain";
    };

    cloudflareTokenFile = lib.mkOption {
      type = lib.types.str;
      description = "Path to file containing CLOUDFLARE_DNS_API_TOKEN=...";
    };

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Caddy virtual hosts to configure, merged into services.caddy.virtualHosts.";
    };

  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    # Caddy with the Cloudflare DNS plugin for DNS-01 challenges
    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
        hash = "sha256-hEHgAG0F0ozHRAPuxEqLyTATBrE+pajeXDiSNwniorg=";
      };

      # Global options block — sets ACME defaults for all vhosts
      globalConfig = ''
        email ${cfg.email}

        acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
      '';

      environmentFile = cfg.cloudflareTokenFile;

      inherit (cfg) virtualHosts;

    };
  };
}
