{
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    ./github-runners.nix
  ];

  # Use TouchID for `sudo` authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "zion";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [
    "root"
    "${config.me.username}"
    "_github-runner"
  ];

  nix.channel.enable = false;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  nix.registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

  users.users."${config.me.username}".home = "/Users/${config.me.username}";
  system.primaryUser = "${config.me.username}";

  environment.systemPackages = with pkgs; [
    restic
    deploy
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 10d";
    interval = {
      # This will run gc everyday at 12:30 AM
      Hour = 0;
      Minute = 30;
    };
  };

  system.stateVersion = 5;
}
