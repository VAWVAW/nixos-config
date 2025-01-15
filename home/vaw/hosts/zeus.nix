{ pkgs, lib, ... }: {
  imports = [ ../common ];

  systemd.user.services."spotifyd".Install.WantedBy = lib.mkForce [ ];

  home = {
    packages = with pkgs; [ texlive.combined.scheme-full ];
    keyboard.options = [ "ctrl:swap_rwin_rctl" ];
    stateVersion = "24.11";
  };

  desktop = {
    enable = true;
    screens = [{
      name = "BOE 0x0BCA Unknown";
      size = "2256x1504";
      scale = "1.25";
    }];
    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%; ${pkgs.brightnessctl}/bin/brightnessctl s 10%'"
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    config.keybindings."XF86AudioMedia" =
      "input type:touchpad events toggle enabled disabled";
    extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
    '';
  };
  services.swayidle.enable = true;
  programs.waybar.enable = true;

  programs.ssh.matchBlocks."nyx" = {
    host = "nyx home.vaw-valentin.de";
    hostname = "home.vaw-valentin.de";
  };
}
