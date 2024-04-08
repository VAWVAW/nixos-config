# TODO:
# - swayidle/hypridle
# - xdg-desktop-portal
#   - PATH on hyprland
#   - move to home-manager
# - waybar signals

{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim plugins
    vim-inspecthi = {
      url = "github:cocopon/inspecthi.vim";
      flake = false;
    };
    vim-colorswatch = {
      url = "github:cocopon/colorswatch.vim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    in {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      pkgs = forEachPkgs (pkgs: import ./pkgs { inherit pkgs; });
      formatter = forEachPkgs (pkgs: pkgs.nixfmt);

      devShells = forEachPkgs (pkgs: import ./shells { inherit pkgs; });

      iso = outputs.nixosConfigurations.iso.config.system.build.isoImage;

      nixosConfigurations = {
        "iso" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/iso ];
          system = "x86_64-linux";
        };

        # Desktop
        "hades" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/hades ];
        };
        # Framework 13 Laptop
        "zeus" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/zeus ];
        };
        # home server
        "athena" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/athena ];
        };
        # hosted server
        "artemis" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/artemis ];
        };
      };

      homeConfigurations = {
        # Desktop
        "vawvaw@hades" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/hades.nix ];
        };
        # Framework 13 Laptop
        "vawvaw@zeus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/zeus.nix ];
        };
        # home server
        "vawvaw@athena" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/athena.nix ];
        };
        # hosted server
        "vawvaw@artemis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "aarch64-linux";
          };
          modules = [ ./home/vawvaw/artemis.nix ];
        };
        # Portable minimum configuration
        "vawvaw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/generic.nix ];
        };
      };
    };
}
