{
  lib,
  ...
}:
{
  imports = [ ../modules/user.nix ];

  nix = {
    settings = {
      # Use all CPU cores
      max-jobs = lib.mkDefault "auto";
      experimental-features = lib.mkDefault "nix-command flakes";
      extra-substituters = [ "https://cache.clan.lol" ];
      extra-trusted-public-keys = [
        "cache.clan.lol-1:3KztgSAB5R1M+Dz7vzkBGzXdodizbgLXGXKXlcQLA28="
      ];
    };
  };
}
