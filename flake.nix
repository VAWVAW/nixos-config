{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      nixvimModule = pkgs: {
        inherit pkgs;
        module = import ./config;
        extraSpecialArgs = { inherit inputs; };
      };
    in {
      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nixvimpkgs = nixvim.legacyPackages.${system};
        in rec {
          default = nixvim;
          nixvim = nixvimpkgs.makeNixvimWithModule (nixvimModule pkgs);
        });
      checks = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nixvimLib = nixvim.lib.${system};
        in {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule
            (nixvimModule pkgs);
        });
    };
}
