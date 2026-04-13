{ config, lib, ... }:

let
  cfg = config.homelab.microvm-host;
in
{
  options.homelab.microvm-host = {
    enable = lib.mkEnableOption "microVM host bridge and NAT";

    bridgeAddress = lib.mkOption {
      type = lib.types.str;
      default = "10.10.0.1/24";
      description = "IP/prefix assigned to the microvm bridge on this host";
    };

    externalInterface = lib.mkOption {
      type = lib.types.str;
      default = "eno1";
      description = "Uplink interface NAT traffic is masqueraded through";
    };

  };

  config = lib.mkIf cfg.enable {
    # Bridge that all VM TAP interfaces join
    systemd.network = {
      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };
      networks = {
        "10-microvm" = {
          matchConfig.Name = "microvm";
          addresses = [ { Address = cfg.bridgeAddress; } ];
          networkConfig.ConfigureWithoutCarrier = true;
        };
        # Any TAP interface the microvm systemd services create gets bridged
        "11-microvm-tap" = {
          matchConfig.Name = "vm-*";
          networkConfig.Bridge = "microvm";
        };
      };
    };

    # NAT so VMs can reach the internet (package downloads, NTP, etc.)
    # VM traffic goes: VM -> microvm bridge -> clark uplink -> LAN/internet
    networking.nat = {
      enable = true;
      internalInterfaces = [ "microvm" ];
       inherit (cfg) externalInterface;
    };
  };
}
