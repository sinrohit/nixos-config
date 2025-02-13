# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }: {

  # Use TouchID for `sudo` authentication
  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "zion";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" "${flake.config.me.username}" ];
  nix.channel.enable = false;

  nix.nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  nix.registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

  services.tailscale.enable = true;

  users.users."${flake.config.me.username}".home = "/Users/${flake.config.me.username}";

  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "build-box.nix-community.org";
    sshUser = "sinrohit";
    sshKey = "/Users/${flake.config.me.username}/.ssh/id_ed25519";
    system = "x86_64-linux";
    supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
    publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVsSVE1NHFBeTdEaDYzckJ1ZFlLZGJ6SkhycmJyck1YTFlsN1BrbWs4OEg=";
  }];
  nix.settings.builders-use-substitutes = true;

  home-manager.users."${flake.config.me.username}" = {
    imports = [
      ../../home/default.nix
    ];
    home.stateVersion = "23.11";
  };
  system.stateVersion = 5;
}
