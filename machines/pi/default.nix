{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.agenix.nixosModules.default
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

    # Required by cloudflared-tunnel
    kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

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
  system.stateVersion = "23.11";
}
