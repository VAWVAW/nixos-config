{ inputs, lib, pkgs, config, outputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModule
    ./features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = (builtins.attrValues outputs.overlays) ++ [
      # use old version of electron for obsidian until wayland bug is fixed
      (final: prev: {
        obsidian = prev.obsidian.override { electron = pkgs.electron_24; };
      })
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [ "electron-24.8.6" ];
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  sops = {
    age.keyFile = "/persist/home/vawvaw/.config/key.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home = {
    username = lib.mkDefault "vawvaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    packages = with pkgs; [ sops psmisc ];

    persistence."/persist/home/vawvaw" = {
      allowOther = true;
      directories = [
        {
          directory = "Documents";
          method = "symlink";
        }
        {
          directory = "Downloads";
          method = "symlink";
        }
      ];
    };

  };
}
