{ pkgs, ... }: {
  desktop.startup_commands = [ "${pkgs.hypridle}/bin/hypridle" ];
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      ignore_empty_input = true
      hide_cursor = true
      no_fade_in = true
      no_fade_out = true
      grace = 0
      disable_loading_bar = false
    }

    background {
      monitor =

      color = rgb(0,0,0)
    }

    label {
      monitor = HDMI-A-2
      position = 0, 120
      halign = center
      valign = center

      text = $TIME
      font_size = 80
      color = rgb(255,255,255)
    }

    input-field {
      monitor = HDMI-A-2
      position = 0, -50
      halign = center
      valign = center
      size = 120, 120
      outline_thickness = 10

      outer_color = rgb(0,0,255)
      inner_color = rgb(200,200,200)
      font_color = rgb(255,255,255)
      fail_color = rgb(255,0,0)
      check_color = rgb(255,255,0)

      placeholder_text = 
      fade_on_empty = false
      hide_input = true
      fail_transition = 0
    }
  '';
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = ${pkgs.procps}/bin/pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock    # avoid starting multiple hyprlock instances.
        before_sleep_cmd = ${pkgs.systemd}/bin/loginctl lock-session                     # lock before suspend.
        after_sleep_cmd = ${pkgs.hyprland}/bin/hyprctl dispatch dpms on                  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 150                                                                    # 2.5min.
        on-timeout = ${pkgs.brightnessctl}/bin/brightnessctl -s set 10                   # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = ${pkgs.brightnessctl}/bin/brightnessctl -r                           # monitor backlight restor.
    }

    # turn off keyboard backlight, uncomment this section if have keyboard backlight.
    listener { 
        timeout = 150                                                                    # 2.5min.
        on-timeout = ${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
        on-resume = ${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
    }

    listener {
        timeout = 300                                                                    # 5min
        on-timeout = ${pkgs.systemd}/bin/loginctl lock-session                           # lock screen when timeout has passed
    }

    listener {
        timeout = 380                                                                    # 5.5min
        on-timeout = ${pkgs.hyprland}/bin/hyprctl dispatch dpms off                      # screen off when timeout has passed
        on-resume = ${pkgs.hyprland}/bin/hyprctl dispatch dpms on                        # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 1200                                                                   # 20min
        on-timeout = ${pkgs.systemd}/bin/systemctl suspend-then-hibernate                # suspend pc
    }
  '';
}
