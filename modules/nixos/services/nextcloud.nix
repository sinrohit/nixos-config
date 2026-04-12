{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.nextcloud;
in
{
  options.homelab.nextcloud = {
    enable = lib.mkEnableOption "nextcloud file sync";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "cloud.sinrohit.com";
      description = "Domain nextcloud is served on";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/media/nextcloud";
      description = "Directory for nextcloud data";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.nextcloud-admin-passwd.file = ../../../secrets/nextcloud-admin-passwd.age;

    services.nextcloud = {
      enable = true;
      https = true;
      hostName = cfg.domain;
      inherit (cfg) home;
      database.createLocally = true;
      package = pkgs.nextcloud32;
      config = {
        adminuser = "nextcloudadmin";
        adminpassFile = config.age.secrets.nextcloud-admin-passwd.path;
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
      };
    };
  };
}
