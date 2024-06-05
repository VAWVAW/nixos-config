{ pkgs, lib, config, ... }: {
  programs.swaylock = {
    enable = true;
    settings = {
      ignore-empty-password = true;

      color = "000000";
      indicator-caps-lock = true;
      indicator-idle-visible = true;
      inside-color = "0000ff";
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command =
          "${pkgs.procps}/bin/pidof swaylock || ${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ] ++ lib.optionals config.services.spotifyd.enable [{
      event = "after-resume";
      command =
        "sleep 2 && ${pkgs.systemd}/bin/systemctl --user restart spotifyd.service";
    }] ++ lib.optionals config.wayland.windowManager.sway.enable [{
      event = "after-resume";
      command = "${pkgs.sway}/bin/swaymsg output \\* dpms on";
    }] ++ lib.optionals config.wayland.windowManager.hyprland.enable [{
      event = "after-resume";
      command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    }];

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 660;
        command = "${pkgs.sway}/bin/swaymsg output \\* dpms off";
        resumeCommand = "${pkgs.sway}/bin/swaymsg output \\* dpms on";
      }
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
      }
    ] ++ lib.optionals config.wayland.windowManager.sway.enable [{
      timeout = 660;
      command = "${pkgs.sway}/bin/swaymsg output \\* dpms off";
      resumeCommand = "${pkgs.sway}/bin/swaymsg output \\* dpms on";
    }] ++ lib.optionals config.wayland.windowManager.hyprland.enable [{
      timeout = 660;
      command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
      resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    }];
  };
}
