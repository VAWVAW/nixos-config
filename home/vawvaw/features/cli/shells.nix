{ pkgs, lib, ... }: {
  imports = [ ./zsh.nix ];

  programs = { bash.enable = true; };

  home.shellAliases = {
    l = "${pkgs.exa}/bin/exa -1";
    ll = "${pkgs.exa}/bin/exa -l --git --no-time";
    la = "${pkgs.exa}/bin/exa -lag --git";
    tree = "${pkgs.exa}/bin/exa -T";

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
