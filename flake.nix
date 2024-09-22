{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.05";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:vawvaw/wallpapers";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, ... }@inputs:
    let
      inherit (self) outputs;
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
      pkgs-unstable = system:
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      nixvimModule = pkgs: {
        inherit pkgs;
        module = import ./nixvim;
        extraSpecialArgs = { inherit inputs; };
      };
    in {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          nixvimpkgs = nixvim.legacyPackages.${system};
        in (import ./pkgs { inherit pkgs; }) // rec {
          # ~ 1 GB
          nixvim = nixvimpkgs.makeNixvimWithModule (nixvimModule pkgs-unstable);
          nixvim-cli = nixvim.extend { disable_nerdfonts = true; };
          # ~ 3 GB
          nixvim-all = nixvim.extend { languages.all.enable = true; };
          nixvim-cli-all = nixvim-all.extend { disable_nerdfonts = true; };
          # ~ 500 MB
          nixvim-small = nixvim.extend {
            plugins = {
              fugitive.gitPackage = null;
              gitsigns.gitPackage = null;
              lualine.gitPackage = null;
              nvim-tree.gitPackage = null;
              lsp.servers = {
                bashls.enable = false;
                jsonls.enable = false;
                yamlls.enable = false;
              };
            };
          };
          nixvim-cli-small = nixvim-small.extend { disable_nerdfonts = true; };
          # ~ 250 MB
          nixvim-minimal =
            nixvim-small.extend { plugins.treesitter.enable = false; };
          nixvim-cli-minimal =
            nixvim-minimal.extend { disable_nerdfonts = true; };
        });

      formatter = forEachPkgs (pkgs: pkgs.nixfmt-classic);

      devShells = forEachPkgs (pkgs: import ./shells { inherit pkgs; });

      iso = outputs.nixosConfigurations."iso".config.system.build.isoImage;
      nixosConfigurations = {
        "iso" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."x86_64-linux".nixvim-cli-small;
          };
          modules =
            [ ./hosts/iso { nixpkgs.hostPlatform.system = "x86_64-linux"; } ];
          system = "x86_64-linux";
        };

        # Desktop
        "hades" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = pkgs-unstable "x86_64-linux";
            nvim = outputs.packages."x86_64-linux".nixvim-all;
          };
          modules = [ ./hosts/hades ];
        };
        # Framework 13 Laptop
        "zeus" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = pkgs-unstable "x86_64-linux";
            nvim = outputs.packages."x86_64-linux".nixvim-all;
          };
          modules = [ ./hosts/zeus ];
        };
        # home server
        "athena" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = pkgs-unstable "x86_64-linux";
            nvim = outputs.packages."x86_64-linux".nixvim-small;
          };
          modules = [ ./hosts/athena ];
        };
        # hosted server
        "artemis" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = pkgs-unstable "aarch64-linux";
            nvim = outputs.packages."aarch64-linux".nixvim-small;
          };
          modules = [ ./hosts/artemis ];
        };
        # raspberry pi 3b
        "nyx" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            pkgs-unstable = pkgs-unstable "aarch64-linux";
            nvim = outputs.packages."aarch64-linux".nixvim-small;
          };
          modules = [ ./hosts/nyx ];
        };
      };

      homeConfigurations = {
        # Desktop
        "vaw@hades" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."x86_64-linux".nixvim-all;
            hostname = "hades";
          };
          modules = [ ./home/vaw/hosts/hades.nix ];
        };
        # Framework 13 Laptop
        "vaw@zeus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."x86_64-linux".nixvim-all;
            hostname = "zeus";
          };
          modules = [ ./home/vaw/hosts/zeus.nix ];
        };
        # home server
        "vaw@athena" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."x86_64-linux".nixvim-small;
            hostname = "athena";
          };
          modules = [ ./home/vaw/hosts/athena.nix ];
        };
        # hosted server
        "vaw@artemis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."aarch64-linux".nixvim-small;
            hostname = "artemis";
          };
          modules = [ ./home/vaw/hosts/artemis.nix ];
        };
        # raspberry pi 3b
        "vaw@nyx" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."aarch64-linux".nixvim-small;
            hostname = "nyx";
          };
          modules = [ ./home/vaw/hosts/nyx.nix ];
        };
        # Portable minimum configuration
        "vaw" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs outputs;
            nvim = outputs.packages."x86_64-linux".nixvim-all;
            hostname = "vaw";
          };
          modules = [ ./home/vaw/hosts/nixos-iso.nix ];
        };
      };
    };
}
