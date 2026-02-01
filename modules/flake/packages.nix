{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = {
        inherit (pkgs) chadwm;
        inherit (pkgs) deploy;
      };
    };
}
