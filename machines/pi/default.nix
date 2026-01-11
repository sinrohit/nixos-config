{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.agenix.nixosModules.default
    ../../modules/nixos
    inputs.addn-hosts.nixosModule
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Disable UAS for external nvme drive
  boot.kernelParams = [
    "usb-storage.quirks=0bda:9210:u"
    "usbcore.autosuspend=-1"
  ];

  # Required by cloudflared-tunnel
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };

  age.secrets = {
    acme-cloudflare = {
      file = ../../secrets/acme-cloudflare.age;
      owner = "nginx";
      group = "users";
    };
    cloudflare-tunnel.file = ../../secrets/cloudflare-tunnel.age;
  };

  networking = {
    hostName = "pi";
    enableIPv6 = true;
    wireless = {
      enable = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        2283
        53
      ];
      allowedUDPPorts = [ 53 ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    btop
  ];
  nixpkgs.hostPlatform = "aarch64-linux";

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    openFirewallWebserver = true;
    queryLogDeleter.enable = true;
    webserverEnabled = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/sinrohit/hosts/master/hosts";
        description = "Steven Black's unified adlist";
      }
    ];
    settings = {
      webserver.port = "8080";
      dns = {
        domainNeeded = true;
        expandHosts = true;
        interface = "ALL";
        listeningMode = "ALL";
        upstreams = [
          "127.0.0.1#5053"
        ];
      };
      dhcp = {
        active = true;
        router = "192.168.1.1"; # Router
        start = "192.168.1.100"; # DHCP pool starts here
        end = "192.168.1.200"; # DHCP pool ends here
        leaseTime = "1d"; # 1 day lease time
        ipv6 = true;
        multiDNS = true;
        hosts = [
          # Static address for Pi-hole itself
          "D8:3A:DD:AA:90:7F,192.168.1.5,${config.networking.hostName},infinite"
        ];
        rapidCommit = true;
      };
      misc.dnsmasq_lines = [
        "dhcp-authoritative"
        "trust-anchor=.,38696,8,2,683D2D0ACB8C9B712A1948B27F741219298D0A450D612C483AF444A4C0FB2B16"
      ];
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [
      8080
    ];
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "::1"
        ]; # Only listen locally (Pi-hole will forward to it)
        port = 5053;
        access-control = [
          "127.0.0.0/8 allow"
          "::1 allow"
        ];
      };
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--advertise-exit-node" ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # allow large file uploads
    clientMaxBodySize = "50000M";

    virtualHosts."vault.rdev.in" = {
      useACMEHost = "rdev.in";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
      };
    };
    virtualHosts."immich.rdev.in" = {
      useACMEHost = "rdev.in";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:2283";
        proxyWebsockets = true;
      };
    };
    virtualHosts."git.rdev.in" = {
      useACMEHost = "rdev.in";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:3002";
        proxyWebsockets = true;
      };
    };
    virtualHosts."pihole.rdev.in" = {
      useACMEHost = "rdev.in";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8080";
        proxyWebsockets = true;
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_PORT = 8222;
    };
  };

  services.immich = {
    enable = true;
    mediaLocation = "/media/immich";
    machine-learning.enable = false;
    host = "0.0.0.0"; # Listen on all interfaces instead of just localhost
    port = 2283;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rsrohitsingh682@gmail.com";

    certs."rdev.in" = {
      domain = "*.rdev.in";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = config.age.secrets.acme-cloudflare.path;
    };
  };

  services.gitea = {
    enable = true;
    database = {
      type = "postgres";
      port = 5432;
    };
    settings.log.LEVEL = "Error";
    settings.service.DISABLE_REGISTRATION = true;
    settings.metrics.ENABLED = true;
    settings.server = {
      DISABLE_ROUTER_LOG = true;
      ROOT_URL = "https://git.rdev.in";
      HTTP_PORT = 3002;
      DOMAIN = "rdev.in";
    };
    settings.security = {
      DISABLE_GIT_HOOKS = false;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "HOME_PI" = {
        credentialsFile = "${config.age.secrets.cloudflare-tunnel.path}";
        default = "http_status:404";
      };
    };
  };

  users = {
    users.nginx.extraGroups = [
      "acme"
      "disk"
    ];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  nix.gc.automatic = true;
  security.sudo.wheelNeedsPassword = false;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
