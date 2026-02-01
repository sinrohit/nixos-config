{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./disko.nix
    inputs.disko.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;

    initrd.availableKernelModules = [
      "ehci_pci"
      "ahci"
      "xhci_pci"
      "nvme"
      "usbhid"
      "sr_mod"
    ];

    # Enable ZFS support
    supportedFilesystems = [ "zfs" ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # VMware, Parallels both only support this being 0 otherwise you see
      # "error switching console mode" on boot.
      systemd-boot.consoleMode = "0";
    };

    # Setup qemu so we can run x86_64 binaries
    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  # Recommended ZFS services
  services.zfs = {
    autoScrub = {
      # weekly integrity checks
      enable = true;
      interval = "weekly";
    };
    trim.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  networking = {
    hostName = "enigma";
    hostId = "3bd6608b";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    # Disable the firewall since we're in a VM and we want to make it
    # easy to visit stuff in here. We only use NAT networking anyways.
    firewall.enable = false;

    # Interface is this on M4
    interfaces.ens160.useDHCP = true;
  };

  time.timeZone = "Asia/Kolkata";

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.font-awesome
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.symbols-only
    ];
  };

  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    xclip
    deploy

    # Packages required for xmonad
    picom
    feh
    ghostty
    st
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "github-runner-runner1"
      "rohit"
    ];
  };

  age.secrets.github-runner-nixos-config-aarch64-linux.file = ../../secrets/github-runner-nixos-config-aarch64-linux.age;

  services = {
    tailscale.enable = true;

    github-runners = {
      "runner1" = {
        enable = true;
        name = "aarch64-linux-runner1";
        url = "https://github.com/sinrohit/nixos-config";
        tokenFile = config.age.secrets.github-runner-nixos-config-aarch64-linux.path;
        extraPackages = with pkgs; [
          cachix
          python3
        ];
      };
    };
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager = {
        gdm.enable = true;
        autoLogin.user = "rohit";
      };
      desktopManager.gnome.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  system.stateVersion = "25.11";
}
