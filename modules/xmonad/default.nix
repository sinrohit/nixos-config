{ pkgs, ... }:
{
  specialisation."xmonad".configuration = {
    services.xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
          ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 3600x2252
        '';
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;

        extraPackages = hp: [
          hp.dbus
          hp.monad-logger
        ];
        config = ./XMonadConfig.hs;
      };
    };
  };
}
