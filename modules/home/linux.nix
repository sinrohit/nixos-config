{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./hyprland
    ./fonts.nix
  ];

  home = {
    packages = with pkgs; [
      firefox
      rofi
      valgrind
      zathura
      xfce.xfce4-terminal
    ];

  };

}
