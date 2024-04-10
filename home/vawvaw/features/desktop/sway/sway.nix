{ config, pkgs, lib, ... }: {
  config = {
    home.packages = with pkgs; [ light grim slurp wl-color-picker ];

    home.sessionVariables = { NIXOS_OZONE_WL = "1"; };

    wayland.windowManager.sway = let
      mouse = "4119:24578:HID_1017:6002_Mouse";
      first_screen = builtins.head config.desktop.screens;
    in {
      enable = true;
      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=sway
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway

        export QT_QPA_PLATFORM="wayland;xcb"
        export GDK_BACKEND=wayland
        export SDL_VIDEODRIVER=wayland

        export BEMENU_BACKEND=wayland
        export MUTTER_DEBUG_DISABLE_HW_CURSORS=1
        export WLR_NO_HARDWARE_CURSORS=1
        export MOZ_ENABLE_WAYLAND=1

        export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
      '';
      extraOptions = [ "--unsupported-gpu" ];
      config = {
        bars = [ ];
        seat."*".hide_cursor = "when-typing enable";

        window = {
          titlebar = true;
          commands = [
            {
              criteria.app_id = "^Tor Browser$";
              command = "floating enable";
            }
            {
              criteria.app_id = "^firefox$";
              command = "border none";
            }
            {
              criteria.app_id = "^librewolf$";
              command = "border none";
            }
          ];
        };

        focus.followMouse = "no";
        workspaceAutoBackAndForth = true;

        keybindings = let
          inherit (config.desktop.keybinds.generated) left down up right;
          mod = builtins.replaceStrings [ "super" "alt" ] [ "mod4" "mod1" ]
            config.desktop.keybinds.generated.mod;
        in {
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+q" = "kill";
          "${mod}+f" = "fullscreen";
          "${mod}+Ctrl+Delete" = "exit";

          # change focus
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";
          "${mod}+a" = "focus parent";
          "${mod}+y" = "focus child";

          # move focused window
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          # change layout
          "${mod}+h" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+s" = "layout stacking";
          "${mod}+e" = "layout toggle split";
          "${mod}+w" = "layout tabbed";

          # floating
          "${mod}+Space" = "focus mode_toggle";
          "${mod}+Shift+Space" = "floating toggle";

          # enable gaming mode
          "${mod}+Ctrl+Shift+Tab" = builtins.replaceStrings [ "\n" ] [ "; " ] ''
            seat '*' hide_cursor when-typing disable
            output '${first_screen.name}' pos 5000 5000
            input 'type:keyboard' xkb_options 'altwin:menu_win,custom:qwertz_y_z'
            mode disabled'';

          # move workspace
          "${mod}+Shift+Left" = "move workspace to output left";
          "${mod}+Shift+Down" = "move workspace to output down";
          "${mod}+Shift+Up" = "move workspace to output up";
          "${mod}+Shift+Right" = "move workspace to output right";
        } //
        # generate workspace configurations
        (builtins.listToAttrs (builtins.concatLists (builtins.genList (x:
          let
            ws = toString (x + 1);
            key = toString (lib.mod (x + 1) 10);
          in [
            {
              name = "${mod}+${key}";
              value = "workspace ${ws}";
            }
            {
              name = "${mod}+Shift+${key}";
              value = "move container to workspace ${ws}; workspace ${ws}";
            }
            {
              name = "${mod}+Shift+Ctrl+${key}";
              value = "move container to workspace ${ws}";
            }
          ]) 10)));

        defaultWorkspace = "workspace --no-auto-back-and-forth 1";

        modes = let
          inherit (config.wayland.windowManager.sway.config) keybindings;
          inherit (config.desktop.keybinds.generated) left down up right;
          mod = builtins.replaceStrings [ "super" "alt" ] [ "mod4" "mod1" ]
            config.desktop.keybinds.generated.mod;
        in {
          "disabled" =
            # get all keybinds that don't contain "Mod1"
            builtins.removeAttrs keybindings
            (builtins.filter (n: lib.hasInfix "Mod1" n)
              (builtins.attrNames keybindings)) //
            # and add the restore option
            {
              "${mod}+Ctrl+Shift+Tab" =
                builtins.replaceStrings [ "\n" ] [ "; " ] ''
                  seat '*' hide_cursor when-typing enable
                  output '${first_screen.name}' pos ${first_screen.position}
                  input 'type:keyboard' xkb_options '${
                    config.wayland.windowManager.sway.config.input."type:keyboard".xkb_options
                  }'
                  mode default'';
            };
          "resize" = {
            "${left}" = "resize shrink width 10 px or 10 ppt";
            "${right}" = "resize grow width 10 px or 10 ppt";
            "${down}" = "resize shrink height 10 px or 10 ppt";
            "${up}" = "resize grow height 10 px or 10 ppt";

            "Left" = "resize shrink width 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Down" = "resize shrink height 10 px or 10 ppt";
            "Up" = "resize grow height 10 px or 10 ppt";

            "Shift+${left}" = "resize shrink width 1 px or 1 ppt";
            "Shift+${right}" = "resize grow width 1 px or 1 ppt";
            "Shift+${down}" = "resize shrink height 1 px or 1 ppt";
            "Shift+${up}" = "resize grow height 1 px or 1 ppt";

            "Shift+Left" = "resize shrink width 1 px or 1 ppt";
            "Shift+Right" = "resize grow width 1 px or 1 ppt";
            "Shift+Down" = "resize shrink height 1 px or 1 ppt";
            "Shift+Up" = "resize grow height 1 px or 1 ppt";
          };
        };
      };
      extraConfig = ''
        # bind mouse
        bindsym --input-device=${mouse} --whole-window button8 workspace next
        bindsym --input-device=${mouse} --whole-window button9 workspace prev
        bindcode 152 exec --no-startup-id ${pkgs.bash}/bin/bash -c "for i in {1..4}; do swaymsg seat - cursor press button1 && swaymsg seat - cursor release button1; done"

        # workspace layout
        workspace --no-auto-back-and-forth 10; layout stacking; workspace --no-auto-back-and-forth 1

        # hide title bar
        default_border pixel 1
      '';
    };
  };
}
