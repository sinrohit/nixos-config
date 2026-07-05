{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (inputs.import-tree ../../modules/nixos/router)
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "comet";

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    rsync
    deploy
    git
  ];

  services = {

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    qemuGuest.enable = true;

    tailscale.enable = true;
  };

  ## -- Router Configs Start -- ##
  homelab.router = {
    network = {
      enable = true;
      wan.macAddress = "bc:24:11:c5:78:c6";
      lan = {
        macAddress = "bc:24:11:51:c5:71";
        address = "10.10.0.1/24";
      };
      # lan.staticLeases = [
      #   {
      #     MACAddress = "b8:85:84:9a:5d:12";
      #     Address = "10.0.0.10";
      #   }
      # ];
    };
    dns.allowedRanges = [
      "127.0.0.0/8 allow"
      "::1 allow"
      "10.10.0.0/24 allow"
      "100.64.0.0/10 allow" # Tailscale CGNAT
    ];
    adguard = {
      host = "10.10.0.1";
      bindHosts = [
        "10.10.0.1"
        "127.0.0.1"
      ];
    };

    dns.enable = true; # brings up both Unbound + AdGuard together

    firewall.enable = true;

    security = {
      enable = true;
      disableIPv6 = true;
    };
  };

  system.stateVersion = "25.11";
}
