{
  pkgs,
  config,
  lib,
  ...
}:

{

  imports = [ ../../config.nix ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  nix.settings.trusted-users = [
    "root"
    "rohit"
  ];

  nix.buildMachines = [
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
  nix.settings.builders-use-substitutes = true;

  users.users.${config.me.username} = {
    isNormalUser = true;
    home = "/home/${config.me.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = lib.getExe pkgs.zsh;
    openssh.authorizedKeys.keys = [ "${config.me.sshKey}" ];
  };

}
