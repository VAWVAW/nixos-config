{ config, lib, pkgs, outputs, ... }: {
  imports = [ ./features/cli ./dummy-persistence.nix ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  programs = { home-manager.enable = true; };

  home = {
    username = lib.mkDefault "vawvaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    packages = with pkgs; [ sops psmisc ];
  };
}
