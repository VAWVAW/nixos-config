{ config, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = let
    inherit (config.desktop.keybinds.generated) left down up right mod;
    hyprland = config.wayland.windowManager.hyprland.finalPackage;
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

        "XDG_DATA_DIRS,$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
      ];

      input = {
        follow_mouse = 2;
        float_switch_override_focus = 0;

        touchpad = {
          disable_while_typing = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          tap-and-drag = true;
        };
      };

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
          padding = 0;
          rounding = 0;
        };
      };

      windowrulev2 = [
        "noborder, class:^firefox$"
        "noborder, class:^librewolf$"

        "float, class:^Tor Browser$"
      ];

      bindm =
        [ "${mod}, mouse:272, movewindow" "${mod}, mouse:273, resizewindow" ];
    };
    extraBinds = let
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
    ] ++ builtins.concatLists (builtins.genList (x:
      let
        ws = toString (x + 1);
        key = toString (lib.mod (x + 1) 10);
      in [
        "${mod}, ${key}, workspace, ${ws}"
        "${mod}+Shift, ${key}, movetoworkspace, ${ws}"
        "${mod}+Ctrl+Shift, ${key}, movetoworkspacesilent, ${ws}"
      ]) 10);

    extraConfig = ''
      submap = resize
      bind = , ${left}, resizeactive, -10 0
      bind = , ${right}, resizeactive, 10 0
      bind = , ${up}, resizeactive, 0 10
      bind = , ${down}, resizeactive, 0 -10
      bind = Shift, ${left}, resizeactive, -1 0
      bind = Shift, ${right}, resizeactive, 1 0
      bind = Shift, ${up}, resizeactive, 0 1
      bind = Shift, ${down}, resizeactive, 0 -1
      submap = reset
    '';
  };
}
