{ config, pkgs, ... }:
{
  age.secrets.forgejo-runner = {
    file = ../../../secrets/forgejo-runner.age;
    owner = "forgejo";
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      url = "https://git.sinrohit.com";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.forgejo-runner.path;
      labels = [ "native:host" ];
    };
  };
}
