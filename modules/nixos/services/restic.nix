{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.restic;

  commonPruneOpts = [
    "--keep-daily 7"
    "--keep-weekly 4"
    "--keep-monthly 6"
    "--keep-yearly 2"
  ];

  commonExclude = [
    "**/.cache"
    "**/cache"
    "**/tmp"
    "**/*.tmp"
    "**/.Trash-*"
  ];

  commonCheckOpts = [ "--read-data-subset=5%" ];
in
{
  options.homelab.restic = {
    enable = lib.mkEnableOption "restic backups";

    immich = {
      remote = {
        enable = lib.mkEnableOption "remote immich backup to hetzner storagebox";

        repository = lib.mkOption {
          type = lib.types.str;
          default = "sftp:hetzner-storagebox:/backups/immich";
          description = "Remote restic repository URI";
        };
      };

      local = {
        enable = lib.mkEnableOption "local immich backup";

        repository = lib.mkOption {
          type = lib.types.str;
          default = "/var/backup/immich";
          description = "Local restic repository path";
        };
      };

      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "/media/immich" ];
        description = "Paths to include in immich backups";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.restic.file = ../../../secrets/restic.age;

    services.restic.backups = lib.mkMerge [
      (lib.mkIf cfg.immich.remote.enable {
        immich = {
          inherit (cfg.immich.remote) repository;
          passwordFile = config.age.secrets.restic.path;
          inherit (cfg.immich) paths;
          exclude = commonExclude;
          initialize = true;
          pruneOpts = commonPruneOpts;
          timerConfig = {
            OnCalendar = "02:00";
            RandomizedDelaySec = "30m";
            Persistent = true;
          };
          runCheck = true;
          checkOpts = commonCheckOpts;
        };
      })

      (lib.mkIf cfg.immich.local.enable {
        immich-local = {
          inherit (cfg.immich.local) repository;
          passwordFile = config.age.secrets.restic.path;
          inherit (cfg.immich) paths;
          exclude = commonExclude;
          initialize = true;
          pruneOpts = commonPruneOpts;
          timerConfig = {
            OnCalendar = "06:00";
            RandomizedDelaySec = "30m";
            Persistent = true;
          };
          runCheck = true;
          checkOpts = commonCheckOpts;
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      restic
    ];
  };
}
