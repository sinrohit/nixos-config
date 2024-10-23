{ ... }:
{
  programs.git = {
    userName = "Rohit Singh";
    userEmail = "rsrohitsingh682@gmail.com";
    includes = [{
      condition = "gitdir:~/euler/**";
      contents = {
        user.email = "rohit.singh@juspay.in";
        user.name = "Rohit Singh";
      };
    }];
    ignores = [ "*~" "*.swp" ];
    aliases = {
      ci = "commit";
    };
    extraConfig = {
      # init.defaultBranch = "master";
      # pull.rebase = "false";
    };
  };

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };
}
