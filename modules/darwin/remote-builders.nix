{ config, ... }:
{

  nix = {
    distributedBuilds = true;
    buildMachines = [
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
    ];
    settings.builders-use-substitutes = true;
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 2;
      protocol = "ssh-ng";
    };
  };
}
