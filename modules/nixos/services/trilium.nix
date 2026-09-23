{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.trilium-server;
in
{
  options.homelab.trilium-server = {
    enable = lib.mkEnableOption "trilium-server password manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8224;
      description = "Port trilium-server listens on";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Interface trilium-server listens on";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/trilium";
      description = "The directory storing the notes database and the configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.trilium-server = {
      enable = true;
      inherit (cfg) port host dataDir;
      package = pkgs.trilium-server;
    };
  };
}
