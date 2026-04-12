{ config, lib, ... }:

let
  cfg = config.homelab.nginx;
  acmeHost = "sinrohit.com";

  # Helper to build a standard SSL vhost that proxies to localhost
  mkProxy = port: {
    useACMEHost = acmeHost;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };
in
{
  options.homelab.nginx = {
    enable = lib.mkEnableOption "nginx reverse proxy for homelab services";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "50000M";

      virtualHosts = lib.mkMerge [
        (lib.mkIf config.homelab.vaultwarden.enable {
          "vault.sinrohit.com" = mkProxy config.homelab.vaultwarden.port;
        })

        (lib.mkIf config.homelab.immich.enable {
          "immich.sinrohit.com" = mkProxy config.homelab.immich.port;
        })

        (lib.mkIf config.homelab.nextcloud.enable {
          ${config.homelab.nextcloud.domain} = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };
        })

        (lib.mkIf config.homelab.forgejo.enable {
          "git.sinrohit.com" = mkProxy config.homelab.forgejo.port;
        })

        (lib.mkIf config.homelab.ente.enable {
          "accounts.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };
          "albums.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };
          "api.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };
          "cast.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };
          "photos.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
          };

          "s3.sinrohit.com" = {
            useACMEHost = acmeHost;
            forceSSL = true;
            locations."/".proxyPass = "http://localhost:9000";
            extraConfig = ''
              client_max_body_size 16G;
              proxy_buffering off;
              proxy_request_buffering off;
            '';
          };
        })
      ];
    };
  };
}
