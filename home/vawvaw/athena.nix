{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];
  programs.zsh.promptColor = "yellow";
  home.shellAliases = {
    nswitch =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild switch --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh && sudo mount /boot -o remount";
    nboot =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild boot --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh && sudo mount /boot -o remount";
    nbuild =
      "nixos-rebuild build --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    ntest =
      "sudo nixos-rebuild test --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    hswitch = "home-manager switch --flake /var/lib/syncthing/data/Documents/nixos-config";

  };
}
