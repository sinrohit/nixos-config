{ pkgs, ... }:
{

  programs = {

    # Better `cat`
    bat.enable = true;

    gpg.enable = !pkgs.stdenv.isDarwin;

    lazygit.enable = true;

    zoxide.enable = true;

    direnv = {
      enable = true;
    };

    atuin = {
      enable = true;
      settings = {
        show_tabs = false;
        style = "compact";
      };
    };
  };
}
