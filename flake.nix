{
  description = "jon work config @ mercury";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }: {
    nixosConfigurations."jon-mercury" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./laptop ];
    };
  };
}
