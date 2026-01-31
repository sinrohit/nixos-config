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
  ];

  # Be careful updating this.
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
    trim.enable = true; # weekly TRIM for SSDs
  };

  networking.hostId = "4fd9f266";

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

  # Interface is this on M1
  networking.interfaces.ens160.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nix.package = pkgs.nixVersions.latest;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable tailscale. We manually authenticate when we want with
  # "sudo tailscale up". If you don't use tailscale, you should comment
  # out or delete all of this.
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

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
  #       user = "greeter";
  #     };
  #     initial_session = {
  #       command = "niri-session";
  #       user = "rohit";
  #     };
  #   };
  # };

  # programs.niri.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager = {
    gdm.enable = true;
    autoLogin.user = "rohit";
  };
  services.xserver.desktopManager.gnome.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
