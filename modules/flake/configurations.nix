{ self, ... }:
{
  flake = {
    nixosConfigurations = {
      clark = self.mkSystem.nixOS "clark" { };
      ema = self.mkSystem.nixOS "ema" { withHomeManager = true; };
      enigma = self.mkSystem.nixOS "enigma" { withHomeManager = true; };
      pi = self.mkSystem.nixOS "pi" { };
      #riscv = self.mkSystem.nixOS "riscv" { };
    };

    darwinConfigurations.zion = self.mkSystem.macOS "zion" { withHomeManager = true; };

  };
}
