{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.immich;
in
{
  options.homelab.immich = {
    enable = lib.mkEnableOption "immich photo management";

    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
      description = "Port immich listens on";
    };

    mediaLocation = lib.mkOption {
      type = lib.types.str;
      default = "/media/immich";
      description = "Directory for immich media storage";
    };

    machineLearning = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable machine learning features";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      package = pkgs.immich;
      inherit (cfg) mediaLocation;
      machine-learning.enable = cfg.machineLearning;
      inherit (cfg) port;
    };
  };
}
