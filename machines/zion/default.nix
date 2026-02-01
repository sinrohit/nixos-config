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

  networking.hostName = "zion";

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix = {
    # These users can add Nix caches.
    settings.trusted-users = [
      "root"
      "${config.me.username}"
      "_github-runner"
    ];

    channel.enable = false;

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
      interval = {
        # This will run gc everyday at 12:30 AM
        Hour = 0;
        Minute = 30;
      };
    };
  };

  users.users."${config.me.username}".home = "/Users/${config.me.username}";
  system.primaryUser = "${config.me.username}";

  environment.systemPackages = with pkgs; [
    restic
    deploy
  ];

  system.stateVersion = 5;
}
