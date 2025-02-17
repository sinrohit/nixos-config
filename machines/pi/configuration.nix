{ config, pkgs, ... }:
{

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
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
    "/mnt/immich" = {
      device = "/dev/sda1";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  age.secrets = {
    acme-cloudflare = {
      file = ../../secrets/acme-cloudflare.age;
      owner = "nginx";
      group = "users";
    };
    ddns-cloudflare = {
      file = ../../secrets/ddns-cloudflare.age;
      owner = "ddns-updater";
      group = "users";
    };
  };

  networking = {
    hostName = "pi";
    wireless = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ git vim ];
  nixpkgs.hostPlatform = "aarch64-linux";

  nix.settings.trusted-users = [ "root" "wheel" ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--advertise-exit-node" ];
  };

  services.ddns-updater = {
    enable = true;
    environment = {
      "CONFIG_FILEPATH" = config.age.secrets.ddns-cloudflare.path;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

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
    mediaLocation = "/mnt/immich/immich";
    machine-learning.enable = false;
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
    users.rohit = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOWUINFSlhsbwckdAlvE/V1ESIk0yXdVvE/BuMEJpEvl"
      ];
    };
    users.nginx.extraGroups = [ "acme" "disk" ];
    users.ddns-updater.isNormalUser = true;
    users.immich.extraGroups = [ "disk" ];
  };

  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
