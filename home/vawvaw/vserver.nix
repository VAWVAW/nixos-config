{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];

  programs.zsh.promptColor = "yellow";
}
