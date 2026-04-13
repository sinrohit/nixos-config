{ config, lib, ... }:

let
  cfg = config.homelab.vaultwarden;
in
{
  options.homelab.vaultwarden = {
    enable = lib.mkEnableOption "vaultwarden password manager";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8222;
      description = "Port vaultwarden listens on";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Interface vaultwarden listens on";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_PORT = cfg.port;
        ROCKET_ADDRESS = cfg.host;
      };
    };
  };
}
