{
  pubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvCnbNCc22/DeR7cZVUHv3PwwfpL6kIAHO4Ns7SMj1h"
  ];

  homeModule = { pkgs, lib, ... }: {
    home.packages = with pkgs; [ sshuttle python3 fd fzf ];

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
    };

    home.shellAliases = {
      g = "git";
      lg = "lazygit";
    };

    programs.bat.enable = true;
    programs.zoxide.enable = true;
    programs.lazygit = {
      enable = true;
    };
  };
}
