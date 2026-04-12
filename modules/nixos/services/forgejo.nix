{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.forgejo;
in
{
  options.homelab.forgejo = {
    enable = lib.mkEnableOption "forgejo git forge";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "git.sinrohit.com";
      description = "Domain forgejo is served on";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port forgejo listens on";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/media/forgejo";
      description = "Directory for forgejo state";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      inherit (cfg) stateDir;
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          DOMAIN = cfg.domain;
          ROOT_URL = "https://${cfg.domain}/";
          HTTP_PORT = cfg.port;
          LANDING_PAGE = "/sinrohit";
        };
        log.LEVEL = "Trace";
        service.DISABLE_REGISTRATION = true;
      };
    };

    environment.systemPackages = with pkgs; [
      forgejo-cli
    ];
  };
}
