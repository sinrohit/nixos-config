{ pkgs, config, ... }:
{

  age.secrets.github-runner-nixos-config-x84_64-linux.file = ../../../secrets/github-runner-nixos-config-x86_64-linux.age;

  services.github-runners = {
    "runner1" = {
      enable = true;
      name = "x84_64-linux-runner1";
      url = "https://github.com/sinrohit/nixos-config";
      tokenFile = config.age.secrets.github-runner-nixos-config-x84_64-linux.path;
      extraPackages = with pkgs; [
        cachix
        python3
      ];
    };
  };
}
