{ pkgs, ... }:
{
  specialisation."dwm".configuration = {
    services.xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override {
          patches = [
            # for external patches
            (pkgs.fetchpatch {
              # replace with actual URL
              url = "https://dwm.suckless.org/patches/vanitygaps/dwm-cfacts-vanitygaps-6.4_combo.diff";
              hash = "sha256-i/lvTKDXdUrtxpx0epBUz+FSSlO2M+CJu/8SFr2wbG0=";
            })
          ];
        };
      };
      displayManager.gdm.enable = true;
    };
  };
}
