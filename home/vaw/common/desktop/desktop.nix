{ config, pkgs, ... }: {

  desktop = {
    theme.wallpaper = let
      repo = pkgs.fetchFromGitHub {
        owner = "vawvaw";
        repo = "wallpapers";
        rev = "210605c09f5f0200ce9a36f338845995874aea3a";
        hash = "sha256-OHfHM6SWSWXAFToizRJxB5NnUPu+Uq2B0C7IY/6BYxI=";
      };
    in "${repo}/kali-contours-blue.png";

    terminal = "${pkgs.foot}/bin/foot";

    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal-gtk.service'"
    ];

    keybinds = let mod = "Super";
    in {
      generated = {
        inherit mod;
        left = "j";
        down = "k";
        up = "l";
        right = "Semicolon";
      };
      binds = [
        {
          mods = [ mod ];
          key = "Return";
          command = config.desktop.terminal;
        }
        {
          mods = [ mod ];
          key = "d";
          command = "${pkgs.bemenu}/bin/bemenu-run";
        }
        {
          mods = [ mod ];
          key = "Bracketright";
          command = "firefox";
        }
        {
          mods = [ "Alt" ];
          key = "Less";
          command = "${pkgs.psmisc}/bin/killall firefox";
        }

        # screenshots
        {
          mods = [ "Alt" "Shift" ];
          key = "s";
          command = ''
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $XDG_PICTURES_DIR/screenshots/$(date '+%F-%T.png')'';
        }
        {
          mods = [ "Alt" "Shift" ];
          key = "a";
          command = "${pkgs.wl-color-picker}/bin/wl-color-picker";
        }

        #power commands
        {
          mods = [ mod "Shift" ];
          key = "Escape";
          command = "systemctl poweroff";
        }
        {
          mods = [ mod "Shift" ];
          key = "f1";
          command = "systemctl hibernate";
        }
        {
          mods = [ mod "Shift" ];
          key = "f2";
          command = "systemctl suspend";
        }

        #audio
        {
          mods = [ mod ];
          key = "XF86AudioRaiseVolume";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        }
        {
          mods = [ mod ];
          key = "XF86AudioLowerVolume";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        }

        # brightness
        {
          mods = [ mod ];
          key = "XF86MonBrightnessUp";
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 1%+";
        }
        {
          mods = [ mod ];
          key = "XF86MonBrightnessDown";
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 1%-";
        }
      ];

      global-binds = [
        #audio
        {
          key = "XF86AudioRaiseVolume";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        }
        {
          key = "XF86AudioLowerVolume";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        }
        {
          key = "XF86AudioMute";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        }
        {
          key = "XF86AudioMicMute";
          command =
            "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        }

        # brightness
        {
          key = "XF86MonBrightnessUp";
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 5%+";
        }
        {
          key = "XF86MonBrightnessDown";
          command = "${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
        }

        # rfkill 
        {
          key = "XF86RFKill";
          command = "${pkgs.util-linux}/bin/rfkill toggle wifi";
        }
      ];

      modes = {
        "resize" = {
          enter = {
            mods = [ mod ];
            key = "r";
          };
          # binds are defined in compositor config
          binds = [ ];
        };
        "open" = {
          enter = {
            mods = [ mod ];
            key = "o";
          };
          binds = [
            {
              key = "f";
              command = "firefox";
            }
            {
              key = "s";
              command = "steam";
            }
            {
              key = "t";
              command = "tor-browser";
            }
            {
              key = "o";
              command = "obsidian";
            }
            {
              key = "l";
              command = "libreoffice";
            }
            {
              key = "m";
              command =
                "${config.desktop.terminal} -e ${pkgs.neomutt}/bin/neomutt";
            }
          ];
        };
        "mirror" = {
          enter = {
            mods = [ mod ];
            key = "m";
          };
          binds = [
            {
              key = "o";
              command = "${pkgs.wl-mirror}/bin/wl-present mirror";
            }
            {
              key = "s";
              command = "${pkgs.wl-mirror}/bin/wl-present set-output";
            }
            {
              key = "r";
              command = "${pkgs.wl-mirror}/bin/wl-present set-region";
            }
            {
              key = "f";
              command = "${pkgs.wl-mirror}/bin/wl-present toggle-freeze";
            }
          ];
        };
      };
    };
  };
}
