{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.forgejo-runners;
in
{
  options.homelab.forgejo-runners = {
    enable = lib.mkEnableOption "forgejo actions runners";

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://git.sinrohit.com";
      description = "URL of the forgejo instance";
    };

    capacity = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Number of concurrent jobs the runner handles";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.forgejo-runner = {
      file = ../../../secrets/forgejo-runner.age;
      owner = "forgejo";
    };

    virtualisation.podman.enable = true;

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        inherit (cfg) url;
        name = config.networking.hostName;
        tokenFile = config.age.secrets.forgejo-runner.path;
        settings.runner.capacity = cfg.capacity;
        labels = [
          "nixos-latest:docker://git.notthebe.ee/notthebee/nix-ci-builder:latest"
          "buildah:docker://quay.io/containers/buildah:latest"
        ];
      };
    };
  };
}
