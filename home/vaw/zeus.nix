{ lib, pkgs, ... }: {
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/common/swayidle.nix
    ./features/desktop/common/syncthing.nix
    ./features/desktop/common/obsidian.nix
  ];

  services.spotifyd.settings.global.device_name = "zeus_spotifyd";
  systemd.user.services."spotifyd".Install.WantedBy = lib.mkForce [ ];

  home.shellAliases = {
    nswitch =
      "sudo nixos-rebuild switch --flake /home/vaw/Documents/nixos-config#";
    nboot =
      "sudo nixos-rebuild boot --flake /home/vaw/Documents/nixos-config#";
  };

  programs = {
    firejail.wrappedBinaries.signal-desktop.executable = lib.mkForce
      "${pkgs.signal-desktop}/bin/signal-desktop --ozone-platform-hint=x11";

    alacritty.settings.font.size = lib.mkForce 8.0;
  };

  home.keyboard.options = [ "ctrl:swap_rwin_rctl" ];

  desktop = {
    screens = [{
      name = "BOE 0x0BCA Unknown";
      size = "2256x1504";
      scale = "1.5";
    }];
    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%; ${pkgs.light}/bin/light -S 10%'"
    ];
  };

  wayland.windowManager.sway.config = {
    keybindings = {
      "XF86AudioMedia" = "input type:touchpad events toggle enabled disabled";
    };

    input."type:touchpad" = {
      natural_scroll = "disabled";
      tap = "enabled";
      middle_emulation = "enabled";
      dwt = "enabled";
      accel_profile = "flat";
      pointer_accel = "1";
    };
  };

  programs.ssh.matchBlocks."nyx" = {
    host = "nyx home.vaw-valentin.de";
    hostname = "home.vaw-valentin.de";
  };
}
