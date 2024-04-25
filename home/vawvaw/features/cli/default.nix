{ pkgs, ... }: {
  imports = [
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./shells.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./vim.nix
  ];

  home.packages = with pkgs; [
    ncdu # TUI disk usage
    eza # colorful ls
    fd # colorful find
    freesweep # minesweeper

    wget
    nixfmt-classic
    file
    lsof
    python311
    unzip

    man
    man-pages
  ];
}
