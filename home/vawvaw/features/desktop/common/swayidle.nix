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
      {
        event = "after-resume";
        command = "${pkgs.sway}/bin/swaymsg output \\* dpms on";
      }
      {
        event = "after-resume";
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ] ++ lib.optionals config.services.spotifyd.enable [{
      event = "after-resume";
      command =
        "sleep 2 && ${pkgs.systemd}/bin/systemctl --user restart spotifyd.service";
    }];

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        timeout = 660;
        command = "${pkgs.sway}/bin/swaymsg output \\* dpms off";
        resumeCommand = "${pkgs.sway}/bin/swaymsg output \\* dpms on";
      }
      {
        timeout = 660;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
      }
    ];
  };
}
