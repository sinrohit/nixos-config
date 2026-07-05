{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-media.nix
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default

    # nixos services
    (inputs.import-tree ../../modules/nixos/services)
    inputs.microvm.nixosModules.host
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable ZFS support
    supportedFilesystems = [ "zfs" ];

    # Setup qemu so we can run aarch64 binaries
    binfmt.emulatedSystems = [ "aarch64-linux" ];
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
  networking.useNetworkd = true;

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
    deploy
    duf
    lsd
    fzf
    inetutils
  ];

  users = {
    users.nginx.extraGroups = [
      "acme"
      "disk"
    ];
  };

  environment.pathsToLink = [ "/share/bash-completion" ];

  security = {
    # Don't require password for sudo
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
  };

  ## -- Homelab Services -- ##
  homelab = {
    acme.enable = true;
    ente.enable = false;
    vaultwarden.enable = false;
    immich.enable = true;
    forgejo.enable = true;
    forgejo-runners.enable = true;
    nginx.enable = true;
    restic = {
      enable = true;
      immich.remote.enable = true;
      immich.local.enable = true;
    };
  };

  homelab.microvm-host = {
    enable = true;
    externalInterface = "enp2s0";
  };

  microvm.vms = {
    vaultwarden-vm = {
      flake = inputs.self;
      autostart = true;
      restartIfChanged = true;
      updateFlake = "git+https://git.sinrohit.com/sinrohit/nixos-config.git";
    };
  };

  system.stateVersion = "25.11";
}
