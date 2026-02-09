{
  disko.devices = {
    # --- NVMe disk (DATA ONLY) ---
    disk.media = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-eui.000000000000000100a075244cad786f";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "media";
            };
          };
        };
      };
    };

    # --- ZFS pool ---
    zpool.media = {
      type = "zpool";

      options.ashift = "12";
      rootFsOptions = {
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
        mountpoint = "none";
      };

      datasets = {
        root = rec {
          type = "zfs_fs";
          mountpoint = "/media";
          options.mountpoint = mountpoint;
        };

        immich = rec {
          type = "zfs_fs";
          mountpoint = "/media/immich";
          options.mountpoint = mountpoint;
          options."com.sun:auto-snapshot" = "true";
        };

        backups = rec {
          type = "zfs_fs";
          mountpoint = "/media/backups";
          options.mountpoint = mountpoint;
          options."com.sun:auto-snapshot" = "true";
        };

        nextcloud = rec {
          type = "zfs_fs";
          mountpoint = "/media/nextcloud";
          options.mountpoint = mountpoint;
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
}
