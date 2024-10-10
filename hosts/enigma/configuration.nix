{ lib, pkgs, ... }:

let
  users = import ../../users { inherit lib; };
  admins = [ "rohit" ];

in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Shared modules
      ../../nixos/common.nix
      ../../nixos/xrdp.nix
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "enigma";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  users.users =
    lib.flip lib.mapAttrs users (name: cfg: {
      shell = lib.getExe pkgs.zsh;
      isNormalUser = true;
      extraGroups =
        lib.optionals (lib.elem name admins)
          [ "networkmanager" "wheel" "docker" ];
      openssh.authorizedKeys.keys = cfg.pubKeys;
    });

  nix.settings.trusted-users = [ "root" ] ++ lib.attrNames users;

  home-manager.users =
    lib.flip lib.mapAttrs users (name: cfg: {
      imports = [
        ../../home/common.nix
        ../../home/neovim.nix
        cfg.homeModule
      ];
      home.stateVersion = "23.11";
    });

  system.stateVersion = "23.11";
}
