{ lib, pkgs, config, outputs, nvim, ... }: {
  imports = [
    ./desktop

    ./btop.nix
    ./git.nix
    ./shells.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    packages = with pkgs; [
      nvim

      ncdu # TUI disk usage
      eza # colorful ls
      fd # colorful find

      wget
      file
      lsof
      python3
      unzip
      psmisc

      man
      man-pages
    ];

    username = lib.mkDefault "vaw";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };

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

  programs.home-manager.enable = true;

  xdg.enable = true;
}
