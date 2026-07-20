{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.default
    inputs.nixbot.nixosModules.nixbot
    # nixos services
    (inputs.import-tree ../../modules/nixos/services)
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "firefly";

    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    rsync
    deploy
    git
  ];

  services = {

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    qemuGuest.enable = true;

    tailscale.enable = true;
  };

  age.secrets = {
    acme-cloudflare-sinrohit = {
      file = ../../secrets/acme-cloudflare-sinrohit.age;
      owner = "caddy";
      group = "caddy";
    };
    nixbot-webhook = {
      file = ../../secrets/nixbot-webhooks-secret.age;
    };
    nixbot-private-key = {
      file = ../../secrets/nixbot-sinrohit.private-key.age;
    };
    nixbot-oauth = {
      file = ../../secrets/nixbot-sinrohit.oauth-key.age;
    };
  };
  homelab = {
    immich = {
      enable = true;
      machineLearning = true;
    };

    restic = {
      enable = true;
      immich.remote.enable = true;
    };

    caddy = {
      enable = true;
      cloudflareTokenFile = config.age.secrets.acme-cloudflare-sinrohit.path;
      virtualHosts = {
        "photos.sinrohit.com".extraConfig = ''
          reverse_proxy http://localhost:2283
        '';
        "immich.sinrohit.com".extraConfig = ''
          reverse_proxy http://localhost:2283
        '';
        "nixbot.sinrohit.com".extraConfig = ''
          reverse_proxy http://localhost:8010
        '';
      };
    };
  };

  services.nixbot = {
    enable = true;
    domain = "nixbot.sinrohit.com";
    port = 8010;
    nginx.enable = false;
    useHTTPS = true;
    admins = [ "github:sinrohit" ];
    github = {
      enable = true;
      appId = 4222232;
      appSecretKeyFile = config.age.secrets.nixbot-private-key.path;
      webhookSecretFile = config.age.secrets.nixbot-webhook.path;
      oauthId = "Iv23liWfIcV2qledLh08";
      oauthSecretFile = config.age.secrets.nixbot-oauth.path;
      topic = "nixbot-sinrohit";
      repoAllowlist = [ "sinrohit/nixos-config" ];
    };
    buildSystems = [ "x86_64-linux" ];
    evalWorkerCount = 2; # limit the number of concurrent evaluation workers
    evalMaxMemorySize = 4096; # per-worker memory limit in MiB
  };

  system.stateVersion = "25.11";
}
