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
        deploy = pkgs.deploy;
      };
    };
}
