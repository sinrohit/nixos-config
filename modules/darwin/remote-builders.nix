{ config, ... }:
{

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
      hostName = "nixos.orb.local";
      maxJobs = 12;
      speedFactor = 2;
      sshUser = "rohit";
      sshKey = "/Users/${config.me.username}/.ssh/id_ed25519";
      systems = [ "aarch64-linux" ];
      supportedFeatures = [
        "kvm"
        "benchmark"
        "big-parallel"
        "nixos-test"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9aV051U2xGU3pMSFZPQjU5U3hsdGpORE5MWXV3S3FBNGlpS0FmNExvOG4=";
    }
  ];
  nix.settings.builders-use-substitutes = true;
}
