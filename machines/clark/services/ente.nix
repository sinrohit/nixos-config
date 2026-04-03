{ config, ... }:
let
  domain = "sinrohit.com";
in
{
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

  systemd.services.minio.environment.MINIO_SERVER_URL = "https://s3.sinrohit.com";

  # Proxy for minio
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services = {

    minio = {
      enable = true;
      # ente's config must match this region!
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
        # Create a local postgres database and set the necessary config in ente
        enableLocalDB = true;
        domain = "api.${domain}";
        # You can hide secrets by setting xyz._secret = file instead of xyz = value.
        # Make sure to not include any of the secrets used here directly
        # in your config. They would be publicly readable in the nix store.
        # Use agenix, sops-nix or an equivalent secret management solution.
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
            # generate with: openssl rand -base64 32
            encryption._secret = config.age.secrets.ente-encryption.path;
            # generate with: openssl rand -base64 64
            hash._secret = config.age.secrets.ente-hash.path;
          };
          # generate with: openssl rand -base64 32
          jwt.secret._secret = config.age.secrets.ente-jwt.path;
        };
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "accounts.${domain}" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
      };
      "albums.${domain}" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
      };
      "api.${domain}" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
      };
      "cast.${domain}" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
      };
      "photos.${domain}" = {
        useACMEHost = "sinrohit.com";
        forceSSL = true;
      };
    };
  };
}
