{
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/common/syncthing.nix
  ];

  services.spotifyd.settings.global.device_name = "zeus_spotifyd";

  battery = {
    enable = true;
    name = "BAT1";
  };

  home.shellAliases = {
    nswitch =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild switch --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
    nboot =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild boot --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
  };

  desktop.screens = [{
    name = "BOE 0x0BCA Unknown";
    size = "2256x1504";
    scale = "1.6";
  }];

  wayland.windowManager.sway.colorscheme = "blue";
}
