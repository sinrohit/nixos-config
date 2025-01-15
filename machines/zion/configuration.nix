# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }: {

  # Use TouchID for `sudo` authentication
  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "zion";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" "rohit" ];
  nix.channel.enable = false;

  nix.nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  nix.registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

  services.tailscale.enable = true;

  users.users."rohit".home = "/Users/rohit";

  home-manager.users."rohit" = {
    imports = [
      ../../home/default.nix
    ];
    home.stateVersion = "23.11";
  };
  system.stateVersion = 5;
}
