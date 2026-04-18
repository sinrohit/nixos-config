{ pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./hyprland
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
