{ pkgs, ... }: {
  imports =
    [ ./btop.nix ./git.nix ./gpg.nix ./shells.nix ./ssh.nix ./vim.nix ./nvim ];

  home.packages = with pkgs; [
    ncdu # TUI disk usage
    exa # colorful ls
    fd # colorful find

    wget
    nixfmt
    file
    lsof
    python311
  ];
}
