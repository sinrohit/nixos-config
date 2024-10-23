{ lib, pkgs, ... }:

let
  users = import ../../../users { inherit lib; };
  admins = [ "rohit" ];

in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixos-unified.sshTarget = "rohit@100.124.228.49";

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

 # home-manager.users =
 #   lib.flip lib.mapAttrs users (name: cfg: {
 #     imports = [
 #    #   ../../home/common.nix
 #    #   ../../home/neovim.nix
 #       cfg.homeModule
 #     ];
 #     home.stateVersion = "23.11";
 #   }); 
  
  # Location: India
  time.timeZone = "Asia/Kolkata";
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Important Nix settings
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" ] ++ lib.attrNames users;
  };

  system.stateVersion = "23.11";
}
