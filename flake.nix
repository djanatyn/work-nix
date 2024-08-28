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

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "repl-flake"
    ];

    extra-substituters = [ "https://cache.mercury.com" ];

    extra-trusted-public-keys = [ "cache.mercury.com:yhfFlgvqtv0cAxzflJ0aZW3mbulx4+5EOZm6k3oML+I=" ];

    extra-trusted-substituters = [ "https://cache.mercury.com" ];

    max-jobs = "auto";

    accept-flake-config = true;

    warn-dirty = false;

    # Keeps Nix from downloading new tarballs quite as often, particularly when
    # running commands like nix run nixpkgs#curl
    tarball-ttl = 86400; # 1 day
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
