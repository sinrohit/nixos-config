{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ (import ../../overlays { inherit inputs; }) ];
        config.allowUnfree = true;
      };
    };
}
