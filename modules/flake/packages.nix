{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        chadwm = pkgs.chadwm;
      };
    };
}
