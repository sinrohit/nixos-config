{ config, lib, ... }:

let
  cfg = config.homelab.acme;
in
{
  options.homelab.acme = {
    enable = lib.mkEnableOption "ACME wildcard cert via Cloudflare DNS";

    email = lib.mkOption {
      type = lib.types.str;
      default = "rsrohitsingh682@gmail.com";
      description = "Email address for ACME registration";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "sinrohit.com";
      description = "Root domain — a wildcard cert for *.domain will be issued";
    };

    dnsResolver = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1:53";
      description = "DNS resolver used for ACME DNS-01 challenge";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.acme-cloudflare-sinrohit = {
      file = ../../../secrets/acme-cloudflare-sinrohit.age;
      owner = "nginx";
      group = "users";
    };

    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;

      certs.${cfg.domain} = {
        domain = "*.${cfg.domain}";
        dnsProvider = "cloudflare";
        inherit (cfg) dnsResolver;
        environmentFile = config.age.secrets.acme-cloudflare-sinrohit.path;
      };
    };
  };
}
