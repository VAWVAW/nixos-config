{
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/hyprland
    ./features/desktop/common/steam.nix
    ./features/desktop/common/lutris.nix
    ./features/desktop/common/syncthing.nix
  ];

  services.spotifyd.settings.global.device_name = "vaw-pc_spotifyd";

  home.shellAliases = {
    nswitch =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake /home/vawvaw/Documents/nixos-config# && sudo umount /boot && sudo mount /boot";
    nboot =
      "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake /home/vawvaw/Documents/nixos-config# && sudo umount /boot && sudo mount /boot";
  };

  home.persistence."/persist/home/vawvaw".directories = [
    "AndroidPictures"
  ];

  wayland.windowManager.sway.colorscheme = "blue";
}
