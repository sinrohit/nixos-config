# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }: {

  # Use TouchID for `sudo` authentication
  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "rohitsingh-M4KLJ7DH4V";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" "rohit.singh" ];

  users.users."rohit.singh".home = "/Users/rohit.singh";

  home-manager.users."rohit.singh" = {
    imports = [
      ../../home/default.nix
    ];
    home.stateVersion = "23.11";
  };
  system.stateVersion = 5;
}
