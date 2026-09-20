{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.microvm.nixosModules.microvm
    ../../modules/nixos/microvm
    (inputs.import-tree ../../modules/nixos/services)
  ];

  networking.hostName = "trilium-vm";

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;

  microvm-base = {
    ip = "10.10.0.12";
    mac = "26:74:91:f8:0e:42";
    vcpu = 2;
    mem = 3072;
    gateway = "10.10.0.1";
  };

  microvm = {
    vsock.cid = 12;
    systemSymlink = true;
    hypervisor = "qemu";
    writableStoreOverlay = "/nix/.rw-store";
    socket = "control.socket";
    interfaces = [
      {
        type = "tap";
        id = "vm-trilium";
        mac = "26:74:91:f8:0e:42";
      }
    ];

    # Persistent data: clark's /var/lib/trilium → /var/lib/trilium in VM
    shares = [
      {
        proto = "virtiofs";
        tag = "trilium-data";
        source = "/media/trilium";
        mountPoint = "/var/lib/trilium";
      }
    ];
  };

  homelab.trilium-server = {
    enable = true;
    port = 8224;
    host = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ 8224 ];
}
