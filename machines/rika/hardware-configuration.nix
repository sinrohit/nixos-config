{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6d323d97-43bb-477a-975a-3bce73bb177e";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/6d323d97-43bb-477a-975a-3bce73bb177e";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/585E-6037";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/media" = {
      device = "/dev/disk/by-uuid/02c73f6b-13f6-412f-8312-fd7db001eb55";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
