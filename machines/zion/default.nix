{
  config,
  inputs,
  ...
}:
{

  imports = [
    ./aerospace.nix
    ./github-runners.nix
    ./remote-builders.nix
  ];

  # Use TouchID for `sudo` authentication
  security.pam.services.sudo_local.touchIdAuth = true;

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

  nix.gc = {
    automatic = true;
  };

  system.stateVersion = 5;
}
