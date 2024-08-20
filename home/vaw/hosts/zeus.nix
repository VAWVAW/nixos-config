{ pkgs, lib, ... }: {
  imports = [
    ../common
    ../desktop

    ../desktop/optional/sway.nix
    ../desktop/optional/swayidle.nix
    ../desktop/optional/waybar
  ];

  services.spotifyd.settings.global.device_name = "zeus_spotifyd";
  systemd.user.services."spotifyd".Install.WantedBy = lib.mkForce [ ];

  home.keyboard.options = [ "ctrl:swap_rwin_rctl" ];

  desktop = {
    screens = [{
      name = "BOE 0x0BCA Unknown";
      size = "2256x1504";
      scale = "1.25";
    }];
    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%; ${pkgs.brightnessctl}/bin/brightnessctl s 10%'"
    ];
  };

  wayland.windowManager.sway.config.keybindings."XF86AudioMedia" =
    "input type:touchpad events toggle enabled disabled";

  programs.ssh.matchBlocks."nyx" = {
    host = "nyx home.vaw-valentin.de";
    hostname = "home.vaw-valentin.de";
  };
}
