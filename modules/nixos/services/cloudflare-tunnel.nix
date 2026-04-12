{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.cloudflare-tunnel;

  # Each ingress rule: a public hostname -> a local service URL
  ingressRuleType = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        example = "vault.sinrohit.com";
        description = "Public hostname to expose via the tunnel";
      };
      service = lib.mkOption {
        type = lib.types.str;
        example = "http://localhost:8222";
        description = "Local service URL to route traffic to";
      };
    };
  };

  # cloudflared expects a YAML config file
  tunnelConfig = {
    tunnel = cfg.tunnelName;
    credentials-file = config.age.secrets.cloudflare-tunnel.path;
    ingress =
      (map (r: {
        inherit (r) service hostname;
      }) cfg.ingress)
      ++ [ { service = "http_status:404"; } ]; # required catch-all
  };

  configFile = (pkgs.formats.yaml { }).generate "cloudflared-config.yaml" tunnelConfig;
in
{
  options.homelab.cloudflare-tunnel = {
    enable = lib.mkEnableOption "cloudflared tunnel";

    tunnelName = lib.mkOption {
      type = lib.types.str;
      description = "Name of the Cloudflare tunnel (must match the credentials file)";
      example = "clark";
    };

    ingress = lib.mkOption {
      type = lib.types.listOf ingressRuleType;
      default = [ ];
      description = "List of ingress rules mapping public hostnames to local services";
      example = [
        {
          hostname = "vault.sinrohit.com";
          service = "http://localhost:8222";
        }
        {
          hostname = "git.sinrohit.com";
          service = "http://localhost:3000";
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.cloudflare-tunnel.file = ../../../secrets/cloudflare-tunnel.age;

    services.cloudflared = {
      enable = true;
      tunnels.${cfg.tunnelName} = {
        inherit configFile;
        default = "http_status:404";
        ingress = lib.listToAttrs (
          map (r: {
            name = r.hostname;
            value = {
              inherit (r) service;
            };
          }) cfg.ingress
        );
        credentialsFile = config.age.secrets.cloudflare-tunnel.path;
      };
    };
  };
}
