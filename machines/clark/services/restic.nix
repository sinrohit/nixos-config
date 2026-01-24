{ config, ... }:
{
  age.secrets.restic.file = ../../../secrets/restic.age;

  services.restic.backups = {
    immich = {
      # Repository configuration
      repository = "sftp:hetzner-storagebox:/backups/immich";
      passwordFile = config.age.secrets.restic.path;

      # Paths to backup
      paths = [
        "/media/immich"
      ];

      # Exclude patterns
      exclude = [
        # Cache directories
        "**/.cache"
        "**/cache"
        "**/tmp"

        # Immich thumbnails (can be regenerated)
        "**/thumbs"
        "**/encoded-video"

        # Temporary files
        "**/*.tmp"
        "**/.Trash-*"
      ];

      # Initialize repository on first run
      initialize = true;

      # Pruning policy - keeps:
      # - Last 7 daily backups
      # - Last 4 weekly backups
      # - Last 6 monthly backups
      # - Last 2 yearly backups
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 2"
      ];

      # Timer configuration - runs daily at 2 AM with a random delay
      timerConfig = {
        OnCalendar = "02:00";
        RandomizedDelaySec = "30m";
        Persistent = true;
      };

      runCheck = true;
      checkOpts = [
        "--read-data-subset=5%" # Check 5% of data each run
      ];
    };
  };
}
