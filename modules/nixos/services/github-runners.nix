{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.github-runners;
in
{
  options.homelab.github-runners = {
    enable = lib.mkEnableOption "github actions runners";

    url = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/sinrohit/nixos-config";
      description = "URL of the github repository";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.github-runner-nixos-config-x84_64-linux.file = ../../../secrets/github-runner-nixos-config-x86_64-linux.age;

    services.github-runners = {
      "runner1" = {
        enable = true;
        name = "x84_64-linux-runner1";
        inherit (cfg) url;
        tokenFile = config.age.secrets.github-runner-nixos-config-x84_64-linux.path;
        extraPackages = with pkgs; [
          cachix
          python3
        ];
      };
    };

    nix.settings.trusted-users = [
      "root"
      "github-runner-runner1"
      "rohit"
    ];
  };
}
