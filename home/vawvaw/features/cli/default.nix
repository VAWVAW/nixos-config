{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./shells.nix
    ./ssh.nix
    ./tmux.nix
    ./vim.nix
    ./nvim
  ];

  home.packages = with pkgs; [
    ncdu # TUI disk usage
    eza # colorful ls
    fd # colorful find
    freesweep # minesweeper

    wget
    nixfmt
    file
    lsof
    python311
    unzip
  ];
}
