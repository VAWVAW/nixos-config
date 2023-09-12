{ pkgs, ... }: {
  imports =
    [ ./btop.nix ./git.nix ./gpg.nix ./shells.nix ./ssh.nix ./vim.nix ./nvim ./direnv.nix ];

  home.packages = with pkgs; [
    ncdu # TUI disk usage
    eza # colorful ls
    fd # colorful find

    wget
    nixfmt
    file
    lsof
    python311
  ];
}
