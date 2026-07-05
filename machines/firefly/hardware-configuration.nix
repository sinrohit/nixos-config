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
      device = "/dev/disk/by-uuid/6a2bfaf5-84b1-4e94-94a9-1ef85b51df2c";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/6a2bfaf5-84b1-4e94-94a9-1ef85b51df2c";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/AAEA-EE88";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/media" = {
      device = "/dev/disk/by-uuid/f02b3758-0f58-4bc4-9ffa-9ba43d26edfa";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/58319267-a0bd-4a05-9395-2e744caeeb51"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
