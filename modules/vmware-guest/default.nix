{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.virtualisation.vmware.guest;
  open-vm-tools = if cfg.headless then pkgs.open-vm-tools-headless else pkgs.open-vm-tools;
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "vmwareGuest" ]
      [
        "virtualisation"
        "vmware"
        "guest"
      ]
    )
  ];

  options.virtualisation.vmware.guest = {
    enable = mkEnableOption "VMWare Guest Support";
    headless = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to disable X11-related features.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64 || pkgs.stdenv.isAarch64;
        message = "VMWare guest is not currently supported on ${pkgs.stdenv.hostPlatform.system}";
      }
    ];

    boot.initrd.availableKernelModules = [ "mptspi" ];

    environment.systemPackages = [ open-vm-tools ];

    systemd.services.vmware = {
      description = "VMWare Guest Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "display-manager.service" ];
      unitConfig.ConditionVirtualization = "vmware";
      serviceConfig.ExecStart = "${open-vm-tools}/bin/vmtoolsd";
    };

    # Mount the vmblock for drag-and-drop and copy-and-paste.
    systemd.mounts = [
      {
        description = "VMware vmblock fuse mount";
        documentation = [
          "https://github.com/vmware/open-vm-tools/blob/master/open-vm-tools/vmblock-fuse/design.txt"
        ];
        unitConfig.ConditionVirtualization = "vmware";
        what = "${open-vm-tools}/bin/vmware-vmblock-fuse";
        where = "/run/vmblock-fuse";
        type = "fuse";
        options = "subtype=vmware-vmblock,default_permissions,allow_other";
        wantedBy = [ "multi-user.target" ];
      }
    ];

    security.wrappers.vmware-user-suid-wrapper = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${open-vm-tools}/bin/vmware-user-suid-wrapper";
    };

    environment.etc.vmware-tools.source = "${open-vm-tools}/etc/vmware-tools/*";

    #services.xserver = {
    #  enable = true;
    #  displayManager = {
    #    sessionCommands = ''
    #      ${pkgs.xorg.xset}/bin/xset r rate 200 40
    #    '';
    #  };

    #  windowManager.xmonad = {
    #    enable = true;
    #    enableContribAndExtras = true;

    #    extraPackages = hp: [
    #      hp.dbus
    #      hp.monad-logger
    #    ];
    #    config = ../xmonad/XMonadConfig.hs;
    #  };
    #};

    programs.hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };

    services.udev.packages = [ open-vm-tools ];
  };
}
