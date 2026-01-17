{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        xmobar = pkgs.xmobar-custom;
        chadwm = pkgs.chadwm;
      };
    };
}
