{ pkgs, lib, ... }: {
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/hyprland
    ./features/desktop/common/steam.nix
    ./features/desktop/common/minecraft.nix
    ./features/desktop/common/lutris.nix
    ./features/desktop/common/syncthing.nix
    ./features/desktop/common/obsidian.nix
  ];

  services.spotifyd.settings.global.device_name = "hades_spotifyd";

  home = {
    shellAliases = {
      nswitch =
        "sudo mount /boot -o remount,rw && sudo nixos-rebuild switch --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
      nboot =
        "sudo mount /boot -o remount,rw && sudo nixos-rebuild boot --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
    };
    keyboard.options = [ "altwin:menu_win" ];
  };

  programs.firejail.wrappedBinaries.mattermost-desktop.executable =
    lib.mkForce "${pkgs.mattermost-desktop}/bin/mattermost-desktop --use-gl=desktop";
  programs.firejail.wrappedBinaries.signal-desktop.executable =
    lib.mkForce "${pkgs.signal-desktop}/bin/signal-desktop --use-gl=desktop";

  desktop = {
    screens = [
      {
        name = "Philips Consumer Electronics Company PHL 243V5 UK01639008163";
        position = "0 0";
        workspaces = [ "1" ];
      }
      {
        name = "Philips Consumer Electronics Company PHL 223V5 ZVC1532001649";
        position = "1920 65";
        workspaces = [ "9" "10" ];
      }
    ];
    startup_commands = [
      "${pkgs.noisetorch}/bin/noisetorch -i"
      "${pkgs.discord}/bin/discord"
      "mattermost-desktop"
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%'"
    ];
  };
}
