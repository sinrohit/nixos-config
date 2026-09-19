{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.microvm.nixosModules.microvm
    ../../modules/nixos/microvm
    (inputs.import-tree ../../modules/nixos/services)
  ];

  networking.hostName = "stirling-pdf-vm";

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;

  microvm-base = {
    ip = "10.10.0.3";
    mac = "e2:25:56:dc:fa:15";
    vcpu = 1;
    mem = 256;
    gateway = "10.10.0.1";
  };

  microvm = {
    systemSymlink = true;
    hypervisor = "qemu";
    writableStoreOverlay = "/nix/.rw-store";
    socket = "control.socket";
    interfaces = [
      {
        type = "tap";
        id = "vm-stirling-pdf";
        mac = "e2:25:56:dc:fa:15";
      }
    ];

    shares = [
      {
        proto = "virtiofs";
        tag = "stirling-pdf-data";
        source = "/var/lib/stirling-pdf";
        mountPoint = "/var/lib/stirling-pdf";
      }
    ];
  };

  homelab.stirling-pdf = {
    enable = true;
    port = 8223;
  };

  networking.firewall.allowedTCPPorts = [ 8223 ];
}
