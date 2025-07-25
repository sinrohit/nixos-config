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
}
