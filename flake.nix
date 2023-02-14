{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    hardware.url = github:nixos/nixos-hardware;
    impermanence.url = github:nix-community/impermanence;
    sops-nix.url = github:mic92/sops-nix;

    flake-programs-sqlite = {
      url = github:wamserma/flake-programs-sqlite;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons.url = gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons;
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    in
    {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      pkgs = forEachPkgs (pkgs: import ./pkgs { inherit pkgs; });
      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # Desktop
        "vaw-pc" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/vaw-pc ];
        };
      };

      homeConfigurations = {
        # Desktop
        "vawvaw@vaw-pc" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/vawvaw/vaw-pc.nix ];
        };
        # Portable minimum configuration
        "vawvaw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/vawvaw/generic.nix ];
        };
      };
    };
}
