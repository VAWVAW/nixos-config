{ inputs, pkgs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModule

    ./common
  ];

  sops = {
    age.keyFile = "/persist/home/vaw/.config/key.txt";
    defaultSopsFile = ../../../secrets/desktop.yaml;
  };

  home = {
    packages = with pkgs; [
      yubioath-flutter
      libreoffice
      d-spy
      qpdfview
      feh
      sops
      freesweep
      libnotify
      foot
      nixfmt-classic
    ];

    persistence."/persist/home/vaw" = {
      allowOther = true;
      directories = [
        {
          directory = "Pictures";
          method = "symlink";
        }
        {
          directory = "Games";
          method = "symlink";
        }
        {
          directory = "Documents";
          method = "symlink";
        }
        {
          directory = "Downloads";
          method = "symlink";
        }
        {
          directory = ".cargo";
          method = "symlink";
        }
        {
          directory = ".rustup";
          method = "symlink";
        }
      ];
    };

    keyboard = {
      layout = "de";
      variant = "us";
      options = [ "altwin:swap_lalt_lwin" "caps:escape" "custom:qwertz_y_z" ];
    };
  };
  desktop = {
    theme.wallpaper = "${inputs.wallpapers}/kali-contours-blue.png";

    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal-gtk.service'"
    ];

    keybinds = let mod = "super";
    in {
      generated = {
        inherit mod;
        left = "j";
        down = "k";
        up = "l";
        right = "semicolon";
      };
      binds = [
        {
          mods = [ mod ];
          key = "return";
          command = "${pkgs.alacritty}/bin/alacritty";
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
          mods = [ "alt" ];
          key = "less";
          command = "${pkgs.psmisc}/bin/killall firefox";
        }

        # screenshots
        {
          mods = [ "alt" "shift" ];
          key = "s";
          command = ''
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $XDG_PICTURES_DIR/screenshots/$(date '+%F-%T.png')'';
        }
        {
          mods = [ "alt" "shift" ];
          key = "a";
          command = "${pkgs.wl-color-picker}/bin/wl-color-picker";
        }

        #power commands
        {
          mods = [ mod "shift" ];
          key = "escape";
          command = "systemctl poweroff";
        }
        {
          mods = [ mod "shift" ];
          key = "f1";
          command = "systemctl hibernate";
        }
        {
          mods = [ mod "shift" ];
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
            "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
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

        # player control
        {
          key = "XF86AudioPlay";
          command = "${pkgs.playerctl}/bin/playerctl -p spotifyd play-pause";
        }
        {
          key = "XF86AudioStop";
          command = "${pkgs.playerctl}/bin/playerctl -p spotifyd stop";
        }
        {
          key = "XF86AudioNext";
          command = "${pkgs.playerctl}/bin/playerctl -p spotifyd next";
        }
        {
          key = "XF86AudioPrev";
          command = "${pkgs.playerctl}/bin/playerctl -p spotifyd previous";
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
                "${pkgs.alacritty}/bin/alacritty -e ${pkgs.neomutt}/bin/neomutt";
            }
          ];
        };
        "spotify" = {
          enter = {
            mods = [ mod ];
            key = "p";
          };
          binds = [
            {
              key = "d";
              command =
                "${pkgs.spotifython-cli}/bin/spotifython-cli queue playlist --playlist-dmenu --dmenu";
            }
            {
              key = "p";
              command = "${pkgs.spotifython-cli}/bin/spotifython-cli play -s";
            }
            {
              key = "o";
              command =
                "${pkgs.spotifython-cli}/bin/spotifython-cli play -s --playlist-dmenu";
            }
            {
              key = "i";
              command =
                "${pkgs.spotifython-cli}/bin/spotifython-cli play --no-shuffle --playlist-dmenu";
            }
            {
              key = "r";
              command =
                "${pkgs.spotifython-cli}/bin/spotifython-cli play --no-shuffle -r --playlist-dmenu";
            }
            {
              key = "s";
              command = "${pkgs.spotifython-cli}/bin/spotifython-cli pause";
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
