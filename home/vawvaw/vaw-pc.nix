{ pkgs, ... }: {
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

  home.persistence."/persist/home/vawvaw".directories = [ "AndroidPictures" ];

  desktop = {
    screens = [
      {
        name = "Philips Consumer Electronics Company PHL 243V5 UK01639008163";
        position = "0 0";
      }
      {
        name = "Philips Consumer Electronics Company PHL 223V5 ZVC1532001649";
        position = "1920 65";
      }
    ];
    startup_commands = [
      "${pkgs.noisetorch}/bin/noisetorch -i"
      "${pkgs.discord}/bin/discord"
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%'"
    ];
  };

  wayland.windowManager.sway.colorscheme = "blue";
}
