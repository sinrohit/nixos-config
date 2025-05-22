{ pkgs, ... }:
let
  dependencies = p: [ p.xmobar ];

  ghc = pkgs.haskellPackages.ghcWithPackages dependencies;

in
pkgs.stdenv.mkDerivation {
  name = "xmobar-custom";
  unpackPhase = ''
    cp ${./xmobar.hs} xmobar.hs
  '';
  buildInputs = [ ghc ];
  buildPhase = ''
    ghc --make xmobar.hs -rtsopts -threaded
  '';
  script = ''
    #!${pkgs.runtimeShell}
    {
      echo "Now running.."
      ${''${placeholder "out"}/bin/xmobar-custom-unwrapped "$@"''}
    } 2>&1 | \
      logger -t xmobar-custom
  '';
  passAsFile = [ "script" ];
  installPhase = ''
    mkdir -p $out/bin
    mv xmobar $out/bin/xmobar-custom-unwrapped
    cp "$scriptPath" $out/bin/xmobar-custom
    chmod +x $out/bin/xmobar-custom
  '';
}
