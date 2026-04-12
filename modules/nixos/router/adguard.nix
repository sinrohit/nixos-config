{ config, lib, ... }:

let
  cfg = config.homelab.router.adguard;
in
{
  options.homelab.router.adguard = {
    enable = lib.mkEnableOption "AdGuard Home DNS filter";

    host = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1";
      description = "Address AdGuard Home web UI listens on";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port for the AdGuard Home web UI";
    };

    bindHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "10.0.0.1"
        "127.0.0.1"
      ];
      description = "Addresses AdGuard DNS listens on";
    };

    upstreamDns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "127.0.0.1:5335" ];
      description = "Upstream DNS resolvers (typically local Unbound)";
    };

    blockingMode = lib.mkOption {
      type = lib.types.enum [
        "default"
        "nxdomain"
        "null_ip"
        "custom_ip"
      ];
      default = "nxdomain";
      description = "How to respond to blocked domains";
    };

    ratelimit = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Max DNS requests per second per client";
    };

    filters = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption { type = lib.types.str; };
            url = lib.mkOption { type = lib.types.str; };
            id = lib.mkOption { type = lib.types.int; };
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
          };
        }
      );
      default = [
        {
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          id = 1;
          enabled = true;
        }
        {
          name = "Steven Black";
          url = "https://raw.githubusercontent.com/sinrohit/hosts/master/hosts";
          id = 2;
          enabled = true;
        }
      ];
      description = "Blocklist filter subscriptions";
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      mutableSettings = false;
      inherit (cfg) host port;
      settings = {
        dns = {
          inherit (cfg) bindHosts upstream_dns ratelimit;
          port = 53;
          bootstrap_dns = cfg.upstreamDns;
          enable_dnssec = true;
          cache_size = 8388608; # 8 MB
          cache_ttl_min = 300;
          cache_ttl_max = 86400;
          blocking_mode = cfg.blockingMode;
          filtering_enabled = true;
        };
        querylog = {
          enabled = true;
          interval = "2160h";
        };
        statistics = {
          enabled = true;
          interval = "24h";
        };
        inherit (cfg) filters;
      };
    };
  };
}
