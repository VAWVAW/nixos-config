{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];

  programs.zsh.promptColor = "yellow";

  home.shellAliases = {
    ntest = "sudo nixos-rebuild test --flake /etc/nixos# --impure";
    nswitch = "sudo nixos-rebuild switch --flake /etc/nixos# --impure";
    nboot = "sudo nixos-rebuild boot --flake /etc/nixos# --impure";
    nbuild = "sudo nixos-rebuild build --flake /etc/nixos# --impure";
  };
}
