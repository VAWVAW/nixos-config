{
  imports = [
    ./global.nix

    ./features/cli/tmux.nix
  ];

  programs.zsh.promptColor = "yellow";

  home.shellAliases = {
    nswitch =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake github:vawvaw/nixos-config# --refresh && sudo umount /boot && sudo mount /boot";
    nboot =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake github:vawvaw/nixos-config# --refresh && sudo umount /boot && sudo mount /boot";
    nbuild =
      "nixos-rebuild build --flake github:vawvaw/nixos-config# --refresh";
    ntest =
      "sudo nixos-rebuild test --flake github:vawvaw/nixos-config# --refresh";
    hswitch = "home-manager switch --flake github:vawvaw/nixos-config";
  };
}
