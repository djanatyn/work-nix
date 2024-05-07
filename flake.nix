{
  description = "jon work config @ mercury";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      kolide-launcher,
    }:
    {
      nixosConfigurations."jon-mercury" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop
          kolide-launcher.nixosModules.kolide-launcher
        ];
      };
    };
}
