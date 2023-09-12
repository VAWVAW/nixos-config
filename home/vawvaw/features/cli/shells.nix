{ pkgs, lib, ... }: {
  imports = [ ./zsh.nix ];

  programs = { bash.enable = true; };

  home.shellAliases = {
    l = "${pkgs.eza}/bin/exa -1";
    ll = "${pkgs.eza}/bin/exa -l --git --no-time";
    la = "${pkgs.eza}/bin/exa -lag --git";
    tree = "${pkgs.eza}/bin/exa -T";

    ntest = lib.mkDefault "sudo nixos-rebuild test --flake /home/vawvaw/Documents/nixos-config#";
    nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake /home/vawvaw/Documents/nixos-config#";
    nboot = lib.mkDefault "sudo nixos-rebuild boot --flake /home/vawvaw/Documents/nixos-config#";
    nbuild = lib.mkDefault "nixos-rebuild build --flake /home/vawvaw/Documents/nixos-config#";
    hswitch = lib.mkDefault "home-manager switch --flake /home/vawvaw/Documents/nixos-config";
    ".." = "cd ..";
    find = "find 2>/dev/null";
    q = "exit";
  };
}
