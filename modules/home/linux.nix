{ pkgs, ... }:
{
  imports = [
    ./bash.nix
  ];

  home = {
    packages = with pkgs; [
      firefox
      rofi
      valgrind
      zathura
      xfce.xfce4-terminal
    ];

    # Make cursor not tiny on HiDPI screens
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
      x11.enable = true;
    };
  };

  xdg = {
    enable = true;
    configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  };
}
