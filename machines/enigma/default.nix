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

  boot.kernelPackages = pkgs.linuxPackages;

  boot.initrd.availableKernelModules = [
    "ehci_pci"
    "ahci"
    "xhci_pci"
    "nvme"
    "usbhid"
    "sr_mod"
  ];

  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Recommended ZFS services
  services.zfs = {
    autoScrub = {
      # weekly integrity checks
      enable = true;
      interval = "weekly";
    };
    trim.enable = true;
  };

  networking.hostId = "3bd6608b";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  networking.hostName = "enigma";

  time.timeZone = "Asia/Kolkata";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # Interface is this on M4
  networking.interfaces.ens160.useDHCP = true;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;

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

  environment.pathsToLink = [ "/share/bash-completion" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager = {
    gdm.enable = true;
    autoLogin.user = "rohit";
  };
  services.xserver.desktopManager.gnome.enable = true;

  nix.settings = {
    trusted-users = [
      "root"
      "github-runner-runner1"
      "rohit"
    ];
  };

  age.secrets.github-runner-nixos-config-aarch64-linux.file = ../../secrets/github-runner-nixos-config-aarch64-linux.age;

  services.github-runners = {
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  system.stateVersion = "25.11";
}
