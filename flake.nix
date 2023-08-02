{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
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
    cspell-nvim = {
      url = "github:davidmh/cspell.nvim";
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
        "vaw-pc" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/vaw-pc ];
        };
        # Laptop
        "vaw-laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/vaw-laptop ];
        };
        # hosted server
        "vserver" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/vserver ];
        };
      };

      homeConfigurations = {
        # Desktop
        "vawvaw@vaw-pc" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/vaw-pc.nix ];
        };
        # Laptop
        "vawvaw@vaw-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/vaw-laptop.nix ];
        };
        # hosted server
        "vawvaw@vserver" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            platform = "x86_64-linux";
          };
          modules = [ ./home/vawvaw/vserver.nix ];
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
