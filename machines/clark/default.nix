{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.agenix.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/media" = {
    device = "/dev/disk/by-label/MEDIA_DISK";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "defaults" # Standard mount options
    ];
  };

  networking.hostName = "clark";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  }; # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xclip
    ghostty
    vim
    btop
    git
    rsync
    restic
    deploy
  ];

  users = {
    users.nginx.extraGroups = [
      "acme"
      "disk"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable tailscale. We manually authenticate when we want with
  # "sudo tailscale up". If you don't use tailscale, you should comment
  # out or delete all of this.
  services.tailscale.enable = true;

  environment.pathsToLink = [ "/share/bash-completion" ];

  age.secrets = {
    acme-cloudflare-sinrohit = {
      file = ../../secrets/acme-cloudflare-sinrohit.age;
      owner = "nginx";
      group = "users";
    };
    cloudflare-tunnel.file = ../../secrets/cloudflare-tunnel.age;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # allow large file uploads
    clientMaxBodySize = "50000M";

    virtualHosts."vault.sinrohit.com" = {
      useACMEHost = "sinrohit.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
      };
    };
    virtualHosts."immich.sinrohit.com" = {
      useACMEHost = "sinrohit.com";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:2283";
        proxyWebsockets = true;
      };
    };
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_PORT = 8222;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rsrohitsingh682@gmail.com";

    certs."sinrohit.com" = {
      domain = "*.sinrohit.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = config.age.secrets.acme-cloudflare-sinrohit.path;
    };
  };

  services.immich = {
    enable = true;
    package = pkgs.immich;
    mediaLocation = "/media/immich";
    machine-learning.enable = true;
    port = 2283;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
