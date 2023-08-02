{ config, lib, pkgs, ... }: {
  imports = [
    ./features/cli
    ./features/cli/tmux.nix
    ../../hosts/iso/home-dummy-persistence.nix
  ];

  programs = {
    zsh.promptColor = "green";
    home-manager.enable = true;
  };

  home = {
    username = lib.mkDefault "vawvaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";

    packages = with pkgs;
      [ sops psmisc age ssh-to-age ] ++ (import ../../shells/default.nix {
        inherit pkgs;
      }).nixos-config.buildInputs;
  };
}
