{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
  ];

  programs = {
    bash.enable = true;
  };

  home.shellAliases = {
    l = "${pkgs.exa}/bin/exa -1";
    ll = "${pkgs.exa}/bin/exa -l --git --no-time";
    la = "${pkgs.exa}/bin/exa -lag --git";
    tree = "${pkgs.exa}/bin/exa -T";

    ntest = lib.mkDefault "sudo nixos-rebuild test --flake /etc/nixos#";
    nswitch = lib.mkDefault "sudo nixos-rebuild switch --flake /etc/nixos#";
    nboot = lib.mkDefault "sudo nixos-rebuild boot --flake /etc/nixos#";
    nbuild = lib.mkDefault "nixos-rebuild build --flake /etc/nixos#";
    hswitch = lib.mkDefault "home-manager switch --flake /etc/nixos";
    ".." = "cd ..";
    find = "find 2>/dev/null";
    q = "exit";
  };
}
