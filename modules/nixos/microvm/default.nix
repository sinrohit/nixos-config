{ lib, config, ... }:

let
  cfg = config.microvm-base;
in
{
  options.microvm-base = {
    ip = lib.mkOption {
      type = lib.types.str;
      description = "Static IP for this VM on the microvm bridge (e.g. 10.10.0.2)";
    };

    mac = lib.mkOption {
      type = lib.types.str;
      description = "MAC address of the VM's TAP interface";
      example = "a2:46:7d:b3:c9:a9";
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      default = "10.10.0.1";
      description = "Gateway IP (bridge address)";
    };

    dns = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1";
      description = "DNS server — defaults to the pi router where unbound/adguard run";
    };

    vcpu = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Number of vCPUs";
    };

    mem = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "RAM in MB";
    };
  };

  ############################################################
  # MicroVM configuration
  ############################################################

  config = {
    microvm = {
      hypervisor = "qemu";
      inherit (cfg) vcpu mem;

      shares = [
        {
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }
      ];
    };

    ############################################################
    # Deterministic NIC name
    ############################################################
    systemd.network.links."10-lan0" = {
      matchConfig.MACAddress = cfg.mac;
      linkConfig.Name = "lan0";
    };

    # Explicit network configuration for lan0
    systemd.network.networks."20-lan0" = {
      matchConfig.Name = "lan0";
      address = [ "${cfg.ip}/24" ];
      gateway = [ "${cfg.gateway}" ];
      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };
      linkConfig.RequiredForOnline = "routable";
    };

    ############################################################
    # Networking - static IP
    ############################################################
    networking = {
      useNetworkd = true;
      useDHCP = false;
      nameservers = [ cfg.dns ];
    };

    networking.defaultGateway = {
      address = "${cfg.gateway}";
      interface = "lan0";
    };

    # VMs don't need a bootloader
    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot.enable = lib.mkForce false;

    services = {
      resolved.enable = false;

      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      journald.extraConfig = ''
        SystemMaxUse=200M
        MaxRetentionSec=7day
      '';
    };

    nix = {
      optimise.automatic = lib.mkForce false;
      settings.auto-optimise-store = lib.mkForce false;
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "25.11";
  };
}
