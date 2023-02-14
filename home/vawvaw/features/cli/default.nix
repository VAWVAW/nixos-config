{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./git.nix
    ./gpg.nix
    ./shells.nix
    ./ssh.nix
    ./vim.nix
  ];

  home.packages = with pkgs; [
    ncdu # TUI disk usage
    exa # colorful ls
    fd # colorful find
    tmux # terminal multiplexer

    nixfmt
    file
  ];
}
