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
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_PORT = cfg.port;
      };
    };
  };
}
