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
  };

  networking = {
    hostName = "pi";
    enableIPv6 = true;
    wireless = {
      enable = true;
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

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      no-hosts = true;
      no-resolv = true;
      no-poll = true;
      server = [
        "9.9.9.9" # Quad9 (privacy-focused)
        "1.1.1.1" # Cloudflare (fast)
        "8.8.8.8" # Google
      ];

      addn-hosts = "${inputs.addn-hosts}/hosts";
      address = [ "/hesads.akamaized.net/::" ];
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
  };

  services.vaultwarden.enable = true;

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
