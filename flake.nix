{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixvim, ... }@inputs:
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
          default = nixvim.extend { languages.all.enable = true; };
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
