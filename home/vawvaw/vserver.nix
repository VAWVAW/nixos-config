{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];

  programs.zsh.promptColor = "yellow";

  home.shellAliases = {
    nswitch = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
    nboot = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
  };
}
