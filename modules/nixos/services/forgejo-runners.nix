{ config, pkgs, ... }:
{
  age.secrets.forgejo-runner = {
    file = ../../../secrets/forgejo-runner.age;
    owner = "forgejo";
  };

  virtualisation.podman.enable = true;

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      url = "https://git.sinrohit.com";
      name = config.networking.hostName;
      tokenFile = config.age.secrets.forgejo-runner.path;
      settings = {
        runner.capacity = 1;
      };
      labels = [
        "nixos-latest:docker://git.notthebe.ee/notthebee/nix-ci-builder:latest"
        "buildah:docker://quay.io/containers/buildah:latest"
      ];
    };
  };
}
