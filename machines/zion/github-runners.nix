{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    inputs.agenix.darwinModules.default
  ];

  users.users._github-runner.home = lib.mkForce "/private/var/lib/github-runners";

  age = {
    identityPaths = [ "/Users/${config.me.username}/.ssh/id_ed25519" ]; # TODO: Find a better way to do this
    secrets = {
      github-runner-fold-macos = {
        file = ../../secrets/github-runner-fold-macos.age;
        owner = "_github-runner";
        group = "_github-runner";
        mode = "600";
      };
      github-runner-nixos-config-macos = {
        file = ../../secrets/github-runner-nixos-config-macos.age;
        owner = "_github-runner";
        group = "_github-runner";
        mode = "600";
      };
      github-runner-nixci-macos = {
        file = ../../secrets/github-runner-nixci-macos.age;
        owner = "_github-runner";
        group = "_github-runner";
        mode = "600";
      };
    };
  };

  services.github-runners = {
    "runner1" = {
      enable = true;
      name = "macos-runner1";
      url = "https://github.com/sinrohit/fold";
      tokenFile = config.age.secrets.github-runner-fold-macos.path;
      extraPackages = [ pkgs.nixci ];
    };
    "runner2" = {
      enable = true;
      name = "macos-runner2";
      url = "https://github.com/sinrohit/nixos-config";
      tokenFile = config.age.secrets.github-runner-nixos-config-macos.path;
      extraPackages = [ pkgs.nixci ];
    };
    "runner3" = {
      enable = true;
      name = "macos-runner3";
      url = "https://github.com/sinrohit/nixci";
      tokenFile = config.age.secrets.github-runner-nixci-macos.path;
      extraPackages = [ pkgs.nixci ];
    };
  };
}
