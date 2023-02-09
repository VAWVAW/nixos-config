{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  programs.bash.enable = true;

  home.shellAliases = {
    l = "${pkgs.exa}/bin/exa -1";
    ll = "${pkgs.exa}/bin/exa -l --git --no-time";
    la = "${pkgs.exa}/bin/exa -lag --git";
    tree = "${pkgs.exa}/bin/exa -T";

    ntest = "sudo nixos-rebuild test --flake /etc/nixos#";
    nswitch = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
    nboot = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
    nbuild = "sudo nixos-rebuild build --flake /etc/nixos#";
    ".." = "cd ..";
    find = "find 2>/dev/null";
    q = "exit";
  };
}
