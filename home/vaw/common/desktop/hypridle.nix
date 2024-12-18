{ config, pkgs, pkgs-stable, lib, ... }:
let hyprland = config.wayland.windowManager.hyprland.finalPackage;
in {
  programs.hyprlock = {
    enable = lib.mkIf config.services.hypridle.enable true;
    package = pkgs-stable.hyprlock;

    settings = let
      first_screen = if (builtins.length config.desktop.screens) > 0 then
        (builtins.head config.desktop.screens).name
      else
        "";
    in {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
        no_fade_in = true;
        no_fade_out = true;
        grace = 0;
        disable_loading_bar = false;
      };

      background = [ ];

      label = [{
        monitor = first_screen;
        position = "0, 120";
        halign = "center";
        valign = "center";

        text = "$TIME";
        font_size = 80;
        color = "rgb(255, 255, 255)";
      }];

      input-field = [{
        monitor = first_screen;
        position = "0, -50";
        halign = "center";
        valign = "center";
        size = "120, 120";
        outline_thickness = 10;

        outer_color = "rgb(0, 0, 255)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(255, 255, 255)";
        fail_color = "rgb(255, 0, 0)";
        check_color = "rgb(255, 255, 0)";

        placeholder_text = "";
        fade_on_empty = false;
        hide_input = true;
        fail_transition = 0;
      }];
    };
  };

  services.hypridle.package = pkgs-stable.hypridle;
  services.hypridle.settings = {
    general = {
      lock_cmd =
        "${pkgs.procps}/bin/pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
      before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      after_sleep_cmd = "${hyprland}/bin/hyprctl dispatch dpms on";
    };

    listener = [
      {
        timeout = 150;
        on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }

      {
        timeout = 150;
        on-timeout =
          "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
        on-resume =
          "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
      }

      {
        timeout = 300;
        on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
      }

      {
        timeout = 380;
        on-timeout = "${hyprland}/bin/hyprctl dispatch dpms off";
        on-resume = "${hyprland}/bin/hyprctl dispatch dpms on";
      }

      {
        timeout = 1200;
        on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
      }
    ];
  };
}
