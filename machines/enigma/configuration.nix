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

  # Workaround the annoying `Failed to start Network Manager Wait Online` error on switch.
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  home-manager.users =
    lib.flip lib.mapAttrs users (name: cfg: {
      imports = [
        ../../home/default.nix
      ];
      home.stateVersion = "23.11";
    });

  system.stateVersion = "23.11";
}
