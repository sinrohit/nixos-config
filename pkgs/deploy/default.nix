{ writeShellApplication }:
writeShellApplication {
  name = "deploy";
  text = builtins.readFile ./deploy;
}
