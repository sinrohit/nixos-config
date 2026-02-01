{ self, ... }:
{

  flake.checks = {
    aarch64-linux = {

      ema = self.nixosConfigurations.ema.config.system.build.toplevel;

      enigma = self.nixosConfigurations.enigma.config.system.build.toplevel;

      pi = self.nixosConfigurations.pi.config.system.build.toplevel;

    };

    x86_64-linux = {

      clark = self.nixosConfigurations.clark.config.system.build.toplevel;

      riscv = self.nixosConfigurations.riscv.config.system.build.toplevel;
    };

    aarch64-darwin.zion = self.darwinConfigurations.zion.config.system.build.toplevel;
  };
}
