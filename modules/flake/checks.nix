{ self, ... }:
{

  flake.checks.aarch64-linux = {

    ema = self.nixosConfigurations.ema.config.system.build.toplevel;

    pi = self.nixosConfigurations.pi.config.system.build.toplevel;
  };

}
