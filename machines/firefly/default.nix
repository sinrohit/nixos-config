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

  age.secrets.acme-cloudflare-sinrohit = {
    file = ../../secrets/acme-cloudflare-sinrohit.age;
    owner = "caddy";
    group = "caddy";
  };

  homelab = {
    immich = {
      enable = true;
      machineLearning = true;
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
      };
    };
  };

  system.stateVersion = "25.11";
}
