{ lib, config, ... }:

let
  cfg = config.homelab.router.network;

  staticLeaseType = lib.types.submodule {
    options = {
      MACAddress = lib.mkOption {
        type = lib.types.str;
        description = "MAC address of the device";
        example = "b8:85:84:9a:5d:12";
      };
      Address = lib.mkOption {
        type = lib.types.str;
        description = "Static IP to assign";
        example = "10.0.0.10";
      };
    };
  };
in
{
  options.homelab.router.network = {
    enable = lib.mkEnableOption "router WAN/LAN network configuration";

    wan = {
      interface = lib.mkOption {
        type = lib.types.str;
        default = "wan0";
        description = "WAN interface name";
      };
      macAddress = lib.mkOption {
        type = lib.types.str;
        description = "MAC address for stable udev naming of the WAN NIC";
        example = "00:e0:4c:2e:54:50";
      };
    };

    lan = {
      interface = lib.mkOption {
        type = lib.types.str;
        default = "lan0";
        description = "LAN interface name";
      };
      macAddress = lib.mkOption {
        type = lib.types.str;
        description = "MAC address for stable udev naming of the LAN NIC";
        example = "d8:3a:dd:aa:90:7f";
      };
      address = lib.mkOption {
        type = lib.types.str;
        default = "10.0.0.1/24";
        description = "Static IP/prefix for the LAN interface";
      };
      dhcpPoolOffset = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "DHCP pool start offset from the network base address";
      };
      dhcpPoolSize = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Number of addresses in the DHCP pool";
      };
      staticLeases = lib.mkOption {
        type = lib.types.listOf staticLeaseType;
        default = [];
        description = "Static DHCP leases";
        example = [{ MACAddress = "b8:85:84:9a:5d:12"; Address = "10.0.0.10"; }];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${cfg.wan.macAddress}", NAME="${cfg.wan.interface}"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${cfg.lan.macAddress}", NAME="${cfg.lan.interface}"
    '';

    systemd.network = {
      enable = true;
      networks = {
        "10-${cfg.wan.interface}" = {
          matchConfig.Name = cfg.wan.interface;
          networkConfig = {
            DHCP            = "ipv4";
            IPv4Forwarding  = true;
            DNS             = "127.0.0.1";
          };
          dhcpV4Config = {
            UseDNS      = false;
            UseNTP      = false;
            UseHostname = false;
          };
          linkConfig.RequiredForOnline = "routable";
        };

        "20-${cfg.lan.interface}" = {
          matchConfig.Name = cfg.lan.interface;
          networkConfig = {
            Address        = cfg.lan.address;
            IPv4Forwarding = true;
            DHCPServer     = true;
            DNS            = lib.elemAt (lib.splitString "/" cfg.lan.address) 0;
          };
          dhcpServerConfig = {
            EmitRouter          = true;
            EmitDNS             = true;
            DNS                 = lib.elemAt (lib.splitString "/" cfg.lan.address) 0;
            EmitNTP             = true;
            NTP                 = lib.elemAt (lib.splitString "/" cfg.lan.address) 0;
            PoolOffset          = cfg.lan.dhcpPoolOffset;
            PoolSize            = cfg.lan.dhcpPoolSize;
            ServerAddress       = cfg.lan.address;
            DefaultLeaseTimeSec = 3600;
          };
          dhcpServerStaticLeases = cfg.lan.staticLeases;
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
