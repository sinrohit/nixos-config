{ flake, ... }:
{
  programs.git = {
    enable = true;
    userName = flake.config.me.fullname;
    userEmail = flake.config.me.email;
    ignores = [ "*~" "*.swp" ];
    aliases = {
      ci = "commit";
    };
    extraConfig = { };
  };

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };
}
