{ self, ... }:
{
  flake = {
    nixosConfigurations = {
      clark = self.mkSystem.nixOS "clark" { };
      ema = self.mkSystem.nixOS "ema" { withHomeManager = true; };
      pi = self.mkSystem.nixOS "pi" { };
      orb = self.mkSystem.nixOS "orb" { withHomeManager = true; };
      riscv = self.mkSystem.nixOS "riscv" { };
    };

    darwinConfigurations.zion = self.mkSystem.macOS "zion" { withHomeManager = true; };

  };
}
