{ config, pkgs, ... }:
{
  age.secrets.nextcloud-admin-passwd.file = ../../../secrets/nextcloud-admin-passwd.age;

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "cloud.sinrohit.com";
    home = "/media/nextcloud";

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
}
