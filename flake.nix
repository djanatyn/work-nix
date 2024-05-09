{
  description = "jon work config @ mercury";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mercury.url = "git+ssh://git@github.com/mercurytechnologies/nixos-configuration.git?ref=main";
  };

  outputs =
    {
      self,
      nixpkgs,
      kolide-launcher,
      mercury,
    }:
    {
      nixosConfigurations."jon-mercury" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop
          kolide-launcher.nixosModules.kolide-launcher
          mercury.nixosModule
        ];
      };
    };
}
