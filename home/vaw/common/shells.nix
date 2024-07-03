{ pkgs, lib, ... }: {
  imports = [ ./zsh.nix ];

  programs = { bash.enable = true; };

  home.shellAliases = {
    l = "${pkgs.eza}/bin/eza -1 --group-directories-first";
    ll = "${pkgs.eza}/bin/eza -lh --git --no-time --color-scale --group-directories-first --icons=always";
    la = "${pkgs.eza}/bin/eza -lah -g --git --color-scale --group-directories-first --time-style=iso --icons=always";
    tree = "${pkgs.eza}/bin/eza -T";

    ntest = lib.mkDefault "sudo nixos-rebuild test --flake /home/vaw/Documents/nixos-config#";
    nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake /home/vaw/Documents/nixos-config#";
    nboot = lib.mkDefault "sudo nixos-rebuild boot --flake /home/vaw/Documents/nixos-config#";
    nbuild = lib.mkDefault "nixos-rebuild build --flake /home/vaw/Documents/nixos-config#";
    hswitch = lib.mkDefault "home-manager switch --flake /home/vaw/Documents/nixos-config";
    ".." = "cd ..";
    find = "find 2>/dev/null";
    q = "exit";
  };
}
