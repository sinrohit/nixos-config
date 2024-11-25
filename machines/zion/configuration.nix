# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }: {

  # Use TouchID for `sudo` authentication
  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "rohitsingh-M4KLJ7DH4V";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [ "root" "rohit.singh" ];

  nix.nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  nix.registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

  users.users."rohit.singh".home = "/Users/rohit.singh";

  home-manager.users."rohit.singh" = {
    imports = [
      ../../home/direnv.nix
      ../../home/gc.nix
      ../../home/git.nix
      ../../home/neovim.nix
      ../../home/nix-index.nix
      ../../home/packages.nix
      ../../home/shell.nix
      ../../home/tmux.nix
    ];
    home.stateVersion = "23.11";
  };
  system.stateVersion = 5;
}
