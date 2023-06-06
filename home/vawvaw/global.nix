{ inputs, lib, pkgs, config, outputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModule
    ./features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  sops = {
    age.keyFile = "/local_persist/home/vawvaw/.config/key.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  programs = { home-manager.enable = true; };

  home = {
    username = lib.mkDefault "vawvaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    packages = with pkgs; [ sops psmisc ];

    persistence = {
      "/persist/home/vawvaw" = {
        directories = [ "Documents" "Downloads" ];
        allowOther = true;
      };
      "/local_persist/home/vawvaw" = { allowOther = true; };
    };
  };
}
