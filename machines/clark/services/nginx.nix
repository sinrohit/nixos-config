{ config, ... }:
{

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # allow large file uploads
    clientMaxBodySize = "50000M";

    virtualHosts = {
      "vault.sinrohit.com" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
        };
      };
      "immich.sinrohit.com" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:2283";
          proxyWebsockets = true;
        };
      };
      ${config.services.nextcloud.hostName} = {
        forceSSL = true;
        useACMEHost = "sinrohit.com";
      };
    };
  };
}
