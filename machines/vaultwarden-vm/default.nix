{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.microvm.nixosModules.microvm
    ../../modules/nixos/microvm
    (inputs.import-tree ../../modules/nixos/services)
  ];

  networking.hostName = "vaultwarden-vm";

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;

  microvm-base = {
    ip = "10.10.0.2";
    mac = "a2:46:7d:b3:c9:a9";
    vcpu = 1;
    mem = 256;
    gateway = "10.10.0.1";
  };

  microvm = {

    hypervisor = "qemu";
    writableStoreOverlay = "/nix/.rw-store";

    socket = "control.socket";

    interfaces = [
      {
        type = "tap";
        id = "vm-vaultwarden";
        mac = "a2:46:7d:b3:c9:a9";
      }
    ];

    # Persistent data: clark's /var/lib/vaultwarden → /var/lib/vaultwarden in VM
    shares = [
      {
        proto = "virtiofs";
        tag = "vaultwarden-data";
        source = "/var/lib/vaultwarden";
        mountPoint = "/var/lib/vaultwarden";
      }
    ];
  };

  homelab.vaultwarden = {
    enable = true;
    port = 8222;
    host = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ 8222 ];
}
