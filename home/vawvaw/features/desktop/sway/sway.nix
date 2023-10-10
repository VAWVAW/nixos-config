{ config, pkgs, lib, ... }:
let
  colorschemes = {
    blue = {
      background = "#285577";
      border = "#4c7899";
      wallpaper = ../wallpapers/kali-contours-blue.png;
    };
    violet = {
      background = "#420A55";
      border = "#800080";
      wallpaper = ../wallpapers/kali-contours-violet.png;
    };
  };
  colorscheme = colorschemes."${config.wayland.windowManager.sway.colorscheme}";
in {

  options.wayland.windowManager.sway.colorscheme = lib.mkOption {
    type = lib.types.enum (builtins.attrNames colorschemes);
    default = "blue";
  };
  config = {
    home.packages = with pkgs; [ light grim slurp wl-color-picker ];

    home.sessionVariables = { NIXOS_OZONE_WL = "1"; };

    wayland.windowManager.sway = let
      primary_screen = "HDMI-A-1";
      secondary_screen = "HDMI-A-2";
      mouse = "4119:24578:HID_1017:6002_Mouse";
    in {
      enable = true;
      extraSessionCommands = ''
        export BEMENU_BACKEND=wayland
        export QT_QPA_PLATFORM="wayland;xcb"
        export MUTTER_DEBUG_DISABLE_HW_CURSORS=1
        export WLR_NO_HARDWARE_CURSORS=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_CURRENT_DESKTOP=sway
        export GDK_BACKEND=wayland
        export SDL_VIDEODRIVER=wayland
        export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
      '';
      extraOptions = [ "--unsupported-gpu" ];
      config = rec {
        colors = {
          focused = rec {
            inherit (colorscheme) background border;
            childBorder = background;
            indicator = "#2e9ef4";
            text = "#ffffff";
          };
        };
        bars = [{
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
          trayOutput = "none";
          position = "bottom";
          colors =
            let inherit (config.wayland.windowManager.sway.config) colors;
            in {
              statusline = "#ffffff";
              background = "#000000";
              focusedWorkspace = {
                inherit (colors.focused) background border text;
              };
              bindingMode = { inherit (colors.urgent) background border text; };
              activeWorkspace = {
                inherit (colors.focusedInactive) background border text;
              };
              inactiveWorkspace = {
                inherit (colors.unfocused) background border text;
              };
            };
        }];
        input = {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_options = "altwin:swap_lalt_lwin,caps:escape,altwin:menu_win";
          };
          "type:touchpad" = {
            natural_scroll = "disabled";
            tap = "enabled";
            middle_emulation = "enabled";
            dwt = "enabled";
            accel_profile = "flat";
            pointer_accel = "1";
          };
        };
        output = {
          "*" = { bg = "${colorscheme.wallpaper} fill"; };
        } //
          # use custom config.desktop module
          (builtins.listToAttrs (builtins.map (s: {
            inherit (s) name;
            value = {
              inherit (s) position scale;
              resolution = s.size;
            };
          }) config.desktop.screens));
        seat = { "*" = { hide_cursor = "when-typing enable"; }; };
        window = {
          hideEdgeBorders = "both";
          titlebar = true;
          commands = [
            {
              command = "border pixel 2";
              criteria = { window_role = "browser"; };
            }
            {
              command = "border pixel 2";
              criteria = { class = "Steam"; };
            }
            {
              command = "border pixel 2";
              criteria = { app_id = "firefox"; };
            }
            {
              command = "floating enable";
              criteria = { title = "Browser$"; };
            }
          ];
        };
        assigns = { "10" = [{ class = "discord"; }]; };
        startup = [{
          command = ''
            ${pkgs.bash}/bin/bash -c "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal-gtk.service"'';
        }] ++
          # use custom config.desktop module
          (builtins.map (cmd: { command = cmd; })
            config.desktop.startup_commands);

        focus.followMouse = "no";
        workspaceAutoBackAndForth = true;

        modifier = "Mod4";
        left = "j";
        down = "k";
        up = "l";
        right = "odiaeresis";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu =
          "${pkgs.bemenu}/bin/bemenu-run --no-exec | xargs swaymsg exec --";

        keybindings = let
          inherit modifier left down up right terminal menu;
          mod = modifier;
          get_i3block_signal = name:
            (builtins.head (builtins.filter (block: block.name == name)
              config.programs.i3blocks.blocks)).signal;
        in {
          "${mod}+Shift+r" = "reload";
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Plus" = "exec firefox";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec --no-startup-id ${menu}";
          "${mod}+f" = "fullscreen";
          "${mod}+Ctrl+Delete" = "exit";
          "Mod1+Shift+s" = ''
            exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $XDG_PICTURES_DIR/screenshots/$(date '+%F-%T.png')'';
          "Mod1+Shift+a" = "exec ${pkgs.wl-color-picker}/bin/wl-color-picker";

          # audio
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+; exec pkill -SIGRTMIN+${
              get_i3block_signal "volume"
            } i3blocks";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; exec pkill -SIGRTMIN+${
              get_i3block_signal "volume"
            } i3blocks";
          "${mod}+XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+; exec pkill -SIGRTMIN+${
              get_i3block_signal "volume"
            } i3blocks";
          "${mod}+XF86AudioLowerVolume" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-; exec pkill -SIGRTMIN+${
              get_i3block_signal "volume"
            } i3blocks";
          "XF86AudioMute" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" =
            "exec --no-startup-id ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          # brightness
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
          "${mod}+XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 1";
          "${mod}+XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 1";

          # player control
          "XF86AudioPlay" =
            "exec --no-startup-id ${pkgs.spotifython-cli}/bin/spotifython-cli play-pause; exec 'sleep 2 && pkill -SIGRTMIN+11 i3blocks'";
          "XF86AudioStop" =
            "exec --no-startup-id ${pkgs.spotifython-cli}/bin/spotifython-cli pause";
          "XF86AudioNext" =
            "exec --no-startup-id ${pkgs.spotifython-cli}/bin/spotifython-cli next";
          "XF86AudioPrev" =
            "exec --no-startup-id ${pkgs.spotifython-cli}/bin/spotifython-cli prev";

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

          "Mod1+less" = "exec killall firefox";

          # power commands
          "${mod}+Shift+Escape" = "exec shutdown now";
          "${mod}+Shift+Ctrl+Escape" = "exec reboot";
          "${mod}+Shift+F1" = "exec systemctl hibernate";
          "${mod}+Shift+F2" = "exec systemctl suspend";

          # change mode
          "${mod}+r" = "mode resize";
          "${mod}+o" = "mode open";
          "${mod}+p" = "mode spotify";

          # enable gaming mode
          "${mod}+Ctrl+Shift+Tab" = builtins.replaceStrings [ "\n" ] [ "" ] ''
            exec ${pkgs.bash}/bin/bash -c "
              swaymsg -- seat '*' hide_cursor when-typing disable;
              swaymsg -- output 'HDMI-A-2' pos 5000 5000;
              swaymsg -- unbindsym --input-device=${mouse} --whole-window button8;
              swaymsg -- unbindsym --input-device=${mouse} --whole-window button9;
              swaymsg -- input 'type:keyboard' xkb_options altwin:menu_win;
            "'';

          # move workspace
          "${mod}+Shift+Left" = "move workspace to output left";
          "${mod}+Shift+Down" = "move workspace to output down";
          "${mod}+Shift+Up" = "move workspace to output up";
          "${mod}+Shift+Right" = "move workspace to output right";

          # workspace 10
          "${mod}+0" = "workspace 10";
          "${mod}+Shift+0" = "move container to workspace 10; workspace 10";
          "${mod}+Shift+Ctrl+0" = "move container to workspace 10";
        } //
        # generate workspace configurations from list and append to keybindings
        # remember to change workspace 10
        builtins.listToAttrs (builtins.concatMap (n: [
          {
            name = "${mod}+${n}";
            value = "workspace ${n}";
          }
          {
            name = "${mod}+Shift+${n}";
            value = "move container to workspace ${n}; workspace ${n}";
          }
          {
            name = "${mod}+Shift+Ctrl+${n}";
            value = "move container to workspace ${n}";
          }
        ]
        # generate list [1..9]
        ) (builtins.genList (x: toString (x + 1)) 9));

        defaultWorkspace = "workspace --no-auto-back-and-forth 1";
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = primary_screen;
          }
          {
            workspace = "9";
            output = secondary_screen;
          }
          {
            workspace = "10";
            output = secondary_screen;
          }
        ];

        modes = let
          inherit modifier left down up right;
          mod = modifier;
        in {
          resize = {
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

            # back to normal
            "Escape" = "mode default";
            "BackSpace" = "mode default";
            "${mod}+r" = "mode default";
            "q" = "mode default";
          };
          open = lib.mkMerge [
            {
              "f" = "exec firefox; mode default";
              "l" = "exec ${pkgs.libreoffice}/bin/libreoffice; mode default";
              "t" = "exec tor-browser; mode default";
              "o" = "exec ${pkgs.obsidian}/bin/obsidian; mode default";
              "m" =
                "exec ${pkgs.alacritty}/bin/alacritty -e ${pkgs.neomutt}/bin/neomutt; mode default";

              # back to normal
              "Escape" = "mode default";
              "BackSpace" = "mode default";
              "${mod}+o" = "mode default";
            }
            (lib.mkIf (builtins.elem pkgs.steam config.home.packages) {
              "s" = "exec ${pkgs.steam}/bin/steam; mode default";
            })
          ];
          spotify = {
            "d" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli queue playlist --playlist-dmenu --dmenu";
            "p" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli play -s t";
            "o" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli play -s t --playlist-dmenu";
            "i" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli play -s f --playlist-dmenu";
            "r" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli play -s f -r t --playlist-dmenu";
            "s" =
              "mode default; exec ${pkgs.spotifython-cli}/bin/spotifython-cli pause";

            # back to normal
            "Escape" = "mode default";
            "BackSpace" = "mode default";
            "${mod}+p" = "mode default";
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
      '';
    };
  };
}
