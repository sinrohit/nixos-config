{
  config,
  ...
}:

{

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  nix = {
    buildMachines = [
      {
        hostName = "build-box.nix-community.org";
        sshUser = "sinrohit";
        sshKey = "/home/${config.me.username}/.ssh/id_ed25519";
        system = "x86_64-linux";
        supportedFeatures = [
          "kvm"
          "benchmark"
          "big-parallel"
        ];
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVsSVE1NHFBeTdEaDYzckJ1ZFlLZGJ6SkhycmJyck1YTFlsN1BrbWs4OEg=";
      }
    ];

    settings = {
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "rohit"
      ];
    };
  };

  users.users.${config.me.username} = {
    isNormalUser = true;
    home = "/home/${config.me.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "${config.me.sshKey}"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2I5q4joEZHECEbEhLvcH1J67NGODrCmjZXwVCoMSLo"
    ];
  };

}
