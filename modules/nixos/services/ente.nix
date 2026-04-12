{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.ente;
  inherit (cfg) domain;
in
{
  options.homelab.ente = {
    enable = lib.mkEnableOption "ente photos service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "sinrohit.com";
      description = "Base domain for ente (subdomains are derived from this)";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      minio-creds.file = ../../../secrets/minio-creds.age;
      ente-minio-user = {
        file = ../../../secrets/ente-minio-user.age;
        owner = "ente";
      };
      ente-minio-passwd = {
        file = ../../../secrets/ente-minio-passwd.age;
        owner = "ente";
      };
      ente-encryption = {
        file = ../../../secrets/ente-encryption.age;
        owner = "ente";
      };
      ente-hash = {
        file = ../../../secrets/ente-hash.age;
        owner = "ente";
      };
      ente-jwt = {
        file = ../../../secrets/ente-jwt.age;
        owner = "ente";
      };
    };

    systemd.services.minio.environment.MINIO_SERVER_URL = "https://s3.${domain}";

    services = {
      minio = {
        enable = true;
        region = "us-east-1";
        rootCredentialsFile = config.age.secrets.minio-creds.path;
        dataDir = [ "/media/minio/data" ];
        configDir = "/media/minio/config";
      };

      ente = {
        web = {
          enable = true;
          domains = {
            accounts = "accounts.${domain}";
            albums = "albums.${domain}";
            cast = "cast.${domain}";
            photos = "photos.${domain}";
          };
        };
        api = {
          enable = true;
          nginx.enable = true;
          enableLocalDB = true;
          domain = "api.${domain}";
          settings = {
            s3 = {
              use_path_style_urls = true;
              b2-eu-cen = {
                endpoint = "https://s3.${domain}";
                region = "us-east-1";
                bucket = "ente";
                key._secret = config.age.secrets.ente-minio-user.path;
                secret._secret = config.age.secrets.ente-minio-passwd.path;
              };
            };
            key = {
              encryption._secret = config.age.secrets.ente-encryption.path;
              hash._secret = config.age.secrets.ente-hash.path;
            };
            jwt.secret._secret = config.age.secrets.ente-jwt.path;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      minio-client
    ];
  };
}
