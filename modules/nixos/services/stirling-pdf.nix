{ config, lib, ... }:

let
  cfg = config.homelab.stirling-pdf;
in
{
  options.homelab.stirling-pdf = {
    enable = lib.mkEnableOption "stirling-pdf Application";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8223;
      description = "Port stirling-pdf listens on";
    };
  };

  config = lib.mkIf cfg.enable {
    services.stirling-pdf = {
      enable = true;
      environment = {
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = true;
        SERVER_PORT = cfg.port;
      };
    };
  };
}
