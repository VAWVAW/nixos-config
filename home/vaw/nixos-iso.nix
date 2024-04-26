{ config, lib, pkgs, ... }: {
  imports = [
    ./generic.nix
    ./features/cli/tmux.nix
  ];

  programs = {
    zsh.promptColor = "green";
  };

  home = {
    username = lib.mkDefault "vaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    packages = with pkgs;
      [ sops psmisc age ssh-to-age ] ++ (import ../../shells/default.nix {
        inherit pkgs;
      }).nixos-config.buildInputs;
  };
}
