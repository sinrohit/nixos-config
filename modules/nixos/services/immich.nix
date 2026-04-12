{ pkgs, ... }:
{

  services.immich = {
    enable = true;
    package = pkgs.immich;
    mediaLocation = "/media/immich";
    machine-learning.enable = true;
    port = 2283;
  };
}
