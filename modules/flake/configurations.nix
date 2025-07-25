{ self, ... }:
{
  flake = {
    nixosConfigurations = {
      ema = self.mkSystem.nixOS "ema" { withHomeManager = true; };
      pi = self.mkSystem.nixOS "pi" { };
      orb = self.mkSystem.nixOS "orb" { };
    };

    darwinConfigurations.zion = self.mkSystem.macOS "zion" { withHomeManager = true; };

  };
}
