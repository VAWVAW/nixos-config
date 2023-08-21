{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];
  programs.zsh.promptColor = "yellow";
  home.shellAliases = {
    nswitch =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh && sudo umount /boot && sudo mount /boot";
    nboot =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh && sudo umount /boot && sudo mount /boot";
    nbuild =
      "nixos-rebuild build --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    ntest =
      "sudo nixos-rebuild test --flake /var/lib/syncthing/data/Documents/nixos-config# --refresh";
    hswitch = "home-manager switch --flake /var/lib/syncthing/data/Documents/nixos-config";

  };
}
