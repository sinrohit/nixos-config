{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-media.nix
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default

    # nixos services
    (inputs.import-tree ./services)
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable ZFS support
    supportedFilesystems = [ "zfs" ];
  };

  # Recommended ZFS services
  services.zfs = {
    autoScrub = {
      # weekly integrity checks
      enable = true;
      interval = "weekly";
    };
    trim.enable = true; # weekly TRIM for SSDs
  };

  networking = {
    hostId = "2dbce559";
    hostName = "clark";
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    }; # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    tailscale.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xclip
    ghostty
    vim
    btop
    git
    rsync
    restic
    deploy
    duf
    lsd
  ];

  users = {
    users.nginx.extraGroups = [
      "acme"
      "disk"
    ];
  };

  environment.pathsToLink = [ "/share/bash-completion" ];

  age.secrets = {
    acme-cloudflare-sinrohit = {
      file = ../../secrets/acme-cloudflare-sinrohit.age;
      owner = "nginx";
      group = "users";
    };
    cloudflare-tunnel.file = ../../secrets/cloudflare-tunnel.age;
  };

  security = {
    # Don't require password for sudo
    sudo.wheelNeedsPassword = false;

    rtkit.enable = true;
    acme = {
      acceptTerms = true;
      defaults.email = "rsrohitsingh682@gmail.com";

      certs."sinrohit.com" = {
        domain = "*.sinrohit.com";
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        environmentFile = config.age.secrets.acme-cloudflare-sinrohit.path;
      };
    };
  };

  system.stateVersion = "25.11";
}
