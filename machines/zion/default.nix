{ config, inputs, ... }:
{

  imports = [ ./aerospace.nix ];

  # Use TouchID for `sudo` authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  networking.hostName = "zion";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # These users can add Nix caches.
  nix.settings.trusted-users = [
    "root"
    "${config.me.username}"
  ];

  nix.channel.enable = false;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
  nix.registry.nixpkgs.flake = inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

  services.tailscale.enable = true;

  users.users."${config.me.username}".home = "/Users/${config.me.username}";
  system.primaryUser = "${config.me.username}";

  nix.gc = {
    automatic = true;
  };

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "build-box.nix-community.org";
      sshUser = "sinrohit";
      sshKey = "/Users/${config.me.username}/.ssh/id_ed25519";
      systems = [ "x86_64-linux" ];
      supportedFeatures = [
        "kvm"
        "benchmark"
        "big-parallel"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVsSVE1NHFBeTdEaDYzckJ1ZFlLZGJ6SkhycmJyck1YTFlsN1BrbWs4OEg=";
    }
    {
      hostName = "aarch64-build-box.nix-community.org";
      maxJobs = 12;
      sshUser = "sinrohit";
      sshKey = "/Users/${config.me.username}/.ssh/id_ed25519";
      systems = [ "aarch64-linux" ];
      supportedFeatures = [
        "kvm"
        "benchmark"
        "big-parallel"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUc5dXlmaHlsaStCUnRrNjR5K25pcXRiK3NLcXVSR0daODdmNFlSYzhFRTE=";
    }
  ];
  nix.settings.builders-use-substitutes = true;

  system.stateVersion = 5;
}
