{ pkgs, ... }: {
  imports = [ ./zsh.nix ];

  programs.bash.enable = true;
  programs.bash.package = pkgs.bashInteractive;

  home.shellAliases = {
    l = "${pkgs.eza}/bin/eza -1 --group-directories-first";
    ll =
      "${pkgs.eza}/bin/eza -lh --git --no-time --color-scale --group-directories-first --icons=always";
    la =
      "${pkgs.eza}/bin/eza -lah -g --git --color-scale --group-directories-first --time-style=iso --icons=always";
    tree = "${pkgs.eza}/bin/eza -T";

    ".." = "cd ..";
    "..." = "cd ../..";
    q = "exit";
  };
}
