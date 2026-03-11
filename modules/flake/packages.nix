{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = {
        inherit (pkgs) deploy;
      };
    };
}
