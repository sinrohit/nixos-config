{ self, ... }:
{
  flake = {
    nixosConfigurations = {
      clark = self.mkSystem.nixOS "clark" { };
      ema = self.mkSystem.nixOS "ema" { withHomeManager = true; };
      enigma = self.mkSystem.nixOS "enigma" { withHomeManager = true; };
      pi = self.mkSystem.nixOS "pi" { };
      vaultwarden-vm = self.mkSystem.nixOS "vaultwarden-vm" { };
      yuta = self.mkSystem.nixOS "yuta" { withHomeManager = true; };
      rika = self.mkSystem.nixOS "rika" { };
      #riscv = self.mkSystem.nixOS "riscv" { };
    };

    darwinConfigurations.zion = self.mkSystem.macOS "zion" { withHomeManager = true; };

  };
}
