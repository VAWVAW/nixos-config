{ config, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = let
    mod = "SUPER";
    left = "j";
    right = "semicolon";
    up = "l";
    down = "k";
    hyprland = config.wayland.windowManager.hyprland.package;
  in {
    enable = true;

    xwayland.enable = true;

    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "HYPRLAND_INSTANCE_SIGNATURE"
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
      ];
    };

    plugins = with pkgs.hyprlandPlugins; [ hy3 ];

    settings = {
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland"
        "SDL_VIDEODRIVER,wayland"

        "LIBVA_DRIVER_NAME,nvidia"

        "BEMENU_BACKEND,wayland"
        "MUTTER_DEBUG_DISABLE_HW_CURSORS,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "us";
        kb_options =
          "altwin:swap_lalt_lwin,caps:escape,ctrl:menu_rctrl,ctrl:swap_rwin_rctl,custom:qwertz_y_z";

        follow_mouse = 2;
        float_switch_override_focus = 0;

        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          tap-and-drag = true;
        };
      };
      monitor = builtins.map (s:
        "desc:${s.name}, ${builtins.replaceStrings [ " " ] [ "x" ] s.size}, ${
          builtins.replaceStrings [ " " ] [ "x" ] s.position
        }, ${s.scale}") config.desktop.screens;

      general = {
        layout = "hy3";
        gaps_in = 0;
        gaps_out = 0;
        cursor_inactive_timeout = 5;
      };
      decoration.drop_shadow = false;
      animations.enabled = false;
      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
      };
      binds.workspace_back_and_forth = true;

      plugin.hy3 = {
        tabs = {
          padding = 1;
          rounding = 0;
        };
      };

      windowrulev2 = [
        "noborder, class:^firefox$"
        "noborder, class:^librewolf$"

        "float, class:^Tor Browser$"
      ];

      workspace = builtins.concatMap
        (s: map (ws: "${toString ws}, monitor:desc:${s.name}") s.workspaces)
        config.desktop.screens;

      exec-once = [
        "${pkgs.swaybg}/bin/swaybg --image ${
          ../wallpapers/kali-contours-blue.png
        } --mode fill"
      ] ++ config.desktop.startup_commands;

      bindm =
        [ "${mod}, mouse:272, movewindow" "${mod}, mouse:273, resizewindow" ];
      bind = let
        movefocus = pkgs.writeTextFile {
          name = "movefocus";
          executable = true;
          text = ''
            ThenWindow="$(${hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq ".address")"
            ${hyprland}/bin/hyprctl dispatch hy3:movefocus "$1"
            NowWindow="$(${hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq ".address")"

            if [ "$NowWindow" == "$ThenWindow" ]; then
              ${hyprland}/bin/hyprctl dispatch movefocus "$1"
            fi

          '';
        };
      in [
        "${mod}+Ctrl, Delete, exit"
        "${mod}+Shift, q, killactive"
        "${mod}+Shift, r, exec, ${hyprland}/bin/hyprctl reload"
        "${mod}, f, fullscreen, 0"
        "${mod} + Shift, Space, togglefloating, active"

        ", mouse:275, workspace, e+1"
        ", mouse:276, workspace, e-1"

        # change focus
        "${mod}, ${left}, exec, ${movefocus} l"
        "${mod}, ${right}, exec, ${movefocus} r"
        "${mod}, ${up}, exec, ${movefocus} u"
        "${mod}, ${down}, exec, ${movefocus} d"

        "${mod}, a, hy3:changefocus, raise"
        "${mod}, y, hy3:changefocus, lower"

        # change layout
        "${mod}, h, hy3:makegroup, h"
        "${mod}, v, hy3:makegroup, v"
        "${mod}, e, hy3:changegroup, opposite"
        "${mod}, w, hy3:changegroup, tab"

        # move window
        "${mod} + Shift, ${left}, hy3:movewindow, l"
        "${mod} + Shift, ${right}, hy3:movewindow, r"
        "${mod} + Shift, ${up}, hy3:movewindow, u"
        "${mod} + Shift, ${down}, hy3:movewindow, d"

        # move workspaces
        "${mod} + Shift, left, movecurrentworkspacetomonitor, l"
        "${mod} + Shift, left, focusmonitor, l"
        "${mod} + Shift, right, movecurrentworkspacetomonitor, r"
        "${mod} + Shift, right, focusmonitor, r"
        "${mod} + Shift, up, movecurrentworkspacetomonitor, u"
        "${mod} + Shift, up, focusmonitor, u"
        "${mod} + Shift, down, movecurrentworkspacetomonitor, d"
        "${mod} + Shift, down, focusmonitor, d"

        # common applications
        "${mod}, Return, exec, ${pkgs.alacritty}/bin/alacritty"
        "${mod}, d, exec, ${pkgs.bemenu}/bin/bemenu-run"
        "${mod}, Bracketright, exec, firefox"
        "Alt, Less, exec, killall firefox"

        "Alt+Shift, s, exec, ${pkgs.grim}/bin/grim -g '$(${pkgs.slurp}/bin/slurp)' $XDG_PICTURES_DIR/screenshots/$(date '+%F-%T.png')"
        "Alt+Shift, a, exec, ${pkgs.wl-color-picker}/bin/wl-color-picker"

        # power commands
        "${mod} + Shift, Escape, exec, systemctl poweroff"
        "${mod} + Shift, F1, exec, systemctl hibernate"
        "${mod} + Shift, F2, exec, systemctl suspend"

        # audio
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "${mod}, XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        "${mod}, XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # brightness
        ", XF86MonBrightnessUp, exec, sudo ${pkgs.light}/bin/light -A 5"
        ", XF86MonBrightnessDown, exec, sudo ${pkgs.light}/bin/light -U 5"
        "${mod}, XF86MonBrightnessUp, exec, sudo ${pkgs.light}/bin/light -A 1"
        "${mod}, XF86MonBrightnessDown, exec, sudo ${pkgs.light}/bin/light -U 1"

        # player control
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl -p spotifyd play-pause"
        ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl -p spotifyd stop"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl -p spotifyd next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl -p spotifyd previous"

        # rfkill
        ", XF86RFKill, exec, ${pkgs.util-linux}/bin/rfkill toggle wifi"
      ] ++ builtins.concatLists (builtins.genList (x:
        let
          ws = toString (x + 1);
          key = toString (lib.mod (x + 1) 10);
        in [
          "${mod}, ${key}, workspace, ${ws}"
          "${mod}+Shift, ${key}, movetoworkspace, ${ws}"
          "${mod}+Ctrl+Shift, ${key}, movetoworkspacesilent, ${ws}"
        ]) 10);
    };

    extraConfig = ''
      # resize mode
      bind = ${mod}, r, submap, resize

      submap = resize
      bind = , ${left}, resizeactive, -10 0
      bind = , ${right}, resizeactive, 10 0
      bind = , ${up}, resizeactive, 0 10
      bind = , ${down}, resizeactive, 0 -10
      bind = Shift, ${left}, resizeactive, -1 0
      bind = Shift, ${right}, resizeactive, 1 0
      bind = Shift, ${up}, resizeactive, 0 1
      bind = Shift, ${down}, resizeactive, 0 -1

      # back to normal
      bind = , Escape, submap, reset
      bind = , BackSpace, submap, reset
      bind = ${mod}, r, submap, reset
      bind = , q, submap, reset
      submap = reset

      # open mode
      bind = ${mod}, o, submap, open

      submap = open
      bind = , f, exec, firefox
      bind = , f, submap, reset
      bind = , s, exec, steam
      bind = , s, submap, reset
      bind = , t, exec, tor-browser
      bind = , t, submap, reset
      bind = , l, exec, libreoffice
      bind = , l, submap, reset
      bind = , o, exec, obsidian
      bind = , o, submap, reset
      bind = , m, exec, ${pkgs.alacritty}/bin/alacritty -e ${pkgs.neomutt}/bin/neomutt
      bind = , m, submap, reset

      # back to normal
      bind = , Escape, submap, reset
      bind = , BackSpace, submap, reset
      bind = ${mod}, o, submap, reset
      bind = , q, submap, reset
      submap = reset

      # spotify mode
      bind = ${mod}, p, submap, spotify

      submap = spotify
      bind = , d, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli queue playlist --playlist-dmenu --dmenu
      bind = , d, submap, reset
      bind = , p, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli play -s t
      bind = , p, submap, reset
      bind = , o, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli play -s t --playlist-dmenu
      bind = , o, submap, reset
      bind = , i, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli play -s f --playlist-dmenu
      bind = , i, submap, reset
      bind = , r, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli play -s f -r t --playlist-dmenu
      bind = , r, submap, reset
      bind = , s, exec, ${pkgs.spotifython-cli}/bin/spotifython-cli pause
      bind = , s, submap, reset

      # back to normal
      bind = , Escape, submap, reset
      bind = , BackSpace, submap, reset
      bind = , q, submap, reset
      submap = reset
    '';
  };
}
