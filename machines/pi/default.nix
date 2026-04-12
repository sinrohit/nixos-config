{ pkgs, inputs, ... }:
{

  imports = [
    (inputs.import-tree ../../modules/nixos/router)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;

    # Fix bcmgenet EEE bug that causes TX queue deadlock under load
    # https://github.com/openwrt/openwrt/issues/16077#issuecomment-2272967079
    kernelParams = [ "bcmgenet.eee=0" ];

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
  };

  networking.hostName = "pi";

  environment.systemPackages = with pkgs; [
    git
    btop
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    tailscale = {
      enable = true;
      extraSetFlags = [ "--advertise-exit-node" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  nix.gc.automatic = true;
  security.sudo.wheelNeedsPassword = false;

  hardware.enableRedistributableFirmware = true;

  ## -- Router Configs Start -- ##
  homelab.router = {
    network = {
      enable = true;
      wan.macAddress = "00:e0:4c:2e:54:50";
      lan.macAddress = "d8:3a:dd:aa:90:7f";
      lan.staticLeases = [
        {
          MACAddress = "b8:85:84:9a:5d:12";
          Address = "10.0.0.10";
        }
      ];
    };

    dns.enable = true; # brings up both Unbound + AdGuard together

    firewall.enable = true;

    security = {
      enable = true;
      disableIPv6 = true;
    };
  };

  ## -- Router Configs Ends -- ##

  system.stateVersion = "23.11";
}
