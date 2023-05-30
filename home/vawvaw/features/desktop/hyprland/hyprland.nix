{ pkgs, lib, inputs, platform, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    recommendedEnvironment = true;
    plugins = [
      inputs.hy3.packages."${platform}".hy3
    ];
    extraConfig =
      let
        right = "odiaeresis";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.bemenu}/bin/bemenu-run";
      in
      ''
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        env = XDG_SESSION_DESKTOP,Hyprland

        env = QT_QPA_PLATFORM,wayland;xcb
        env = GDK_BACKEND,wayland
        env = SDL_VIDEODRIVER,wayland
        env = CLUTTER_BACKEND,wayland

        env = BEMENU_BACKEND,wayland
        env = MOZ_ENABLE_WAYLAND,1
        env = MUTTER_DEBUG_DISABLE_HW_CURSORS,1
        env = WLR_NO_HARDWARE_CURSORS,1

        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = LIBVA_DRIVER_NAME,nvidia
        env = WLR_DRM_NO_ATOMIC,1

        monitor = HDMI-A-1,preferred,0x0,1
        monitor = HDMI-A-2,preferred,1920x65,1

        input {
          kb_layout = de
          kb_options = altwin:swap_lalt_lwin,caps:escape,altwin:menu_win
          accel_profile = flat
          sensitivity = 1.3

          follow_mouse = 2
          float_switch_override_focus = 0

          touchpad {
            clickfinger_behavior = true
            tap-and-drag = true
          }
        }

        general {
          layout = hy3
          gaps_in = 0
          gaps_out = 0
          no_focus_fallback = true
        }

        misc {
          disable_autoreload = true
        }

        decoration {
          blur = false
          drop_shadow = false
        }

        animations {
          enabled = false
        }

        dwindle {
          force_split = 2
          preserve_split = true
        }

        binds {
          workspace_back_and_forth = true;
        }

        # keybinds
        $mod = SUPER
        $left = j
        $right = odiaeresis
        $up = l
        $down = k

        # mouse
        bindm = $mod, mouse:272, movewindow
        bindm = $mod, mouse:273, resizewindow

        bind = $mod + SHIFT, q, killactive, 
        bind = $mod + SHIFT, r, exec, ${pkgs.hyprland}/bin/hyprctl reload
        bind = $mod + CTRL, Delete, exit, 
        bind = $mod, f, fullscreen, 0

        bind = $mod, d, exec, ${menu}
        bind = $mod, Return, exec, ${terminal}
        bind = $mod, Plus, exec, firefox
        bind = ALT + SHIFT, s, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $XDG_PICTURES_DIR/screens    hots/$(date '+%F-%T.png')
        bind = ALT + SHIFT, a, exec, ${pkgs.wl-color-picker}/bin/wl-color-picker

        # power commands
        bind = $mod + SHIFT, Escape, exec, shutdown now
        bind = $mod + CTRL + SHIFT, Escape, exec, reboot
        bind = $mod + SHIFT, F1, exec, systemctl hibernate
        bind = $mod + SHIFT, F2, exec, systemctl suspend

        # audio
        bind = , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bind = , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bind = $mod, XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
        bind = $mod, XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
        bind = , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bind = , XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

        # brightness
        bind = , XF86MonBrightnessUp, exec, sudo ${pkgs.light}/bin/light -A 5
        bind = , XF86MonBrightnessDown, exec, sudo ${pkgs.light}/bin/light -U 5

        # player control
        bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
        bind = , XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop
        bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
        bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous

        # resize mode
        bind = $mod, r, submap, resize

        submap = resize
        bind = , $left, resizeactive, -10 0
        bind = , $right, resizeactive, 10 0
        bind = , $up, resizeactive, 0 10
        bind = , $down, resizeactive, 0 -10
        bind = SHIFT, $left, resizeactive, -1 0
        bind = SHIFT, $right, resizeactive, 1 0
        bind = SHIFT, $up, resizeactive, 0 1
        bind = SHIFT, $down, resizeactive, 0 -1

        # back to normal
        bind = , Escape, submap, reset
        bind = , BackSpace, submap, reset
        bind = $mod, r, submap, reset
        bind = , q, submap, reset
        submap = reset

        # open mode
        bind = $mod, o, submap, open

        submap = open
        bind = , f, exec, firefox
        bind = , f, submap, reset
        bind = , s, exec, ${pkgs.steam}/bin/steam
        bind = , s, submap, reset
        bind = , t, exec, tor-browser
        bind = , t, submap, reset
        bind = , m, exec, ${terminal} -e ${pkgs.neomutt}/bin/neomutt
        bind = , m, submap, reset

        # back to normal
        bind = , Escape, submap, reset
        bind = , BackSpace, submap, reset
        bind = , q, submap, reset
        submap = reset

        # spotify mode
        bind = $mod, p, submap, spotify

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

        # gaming hack
        bind = $mod + CTRL, Tab, exec, ${pkgs.hyprland}/bin/hyprctl --batch 'keyword monitor HDMI-A-2,preferred,3000x0,1; keyword input:kb_options altwin:menu_win; keyword unbind ,mouse:275; keyword unbind ,mouse:276'
        bind = $mod + CTRL + SHIFT, Tab, exec, ${pkgs.hyprland}/bin/hyprctl --batch 'keyword monitor HDMI-A-2,preferred,1920x65,1; keyword input:kb_options altwin:swap_lalt_lwin,caps:escape,altwin:menu_win; keyword bind ,mouse:275,workspace,e+1; keyword bind ,mouse:276,workspace,e-1'


        # floating
        bind = $mod + SHIFT, Space, togglefloating, active

        # change focus
        bind = $mod, $left, hy3:movefocus, l
        bind = $mod, $right, hy3:movefocus, r
        bind = $mod, $up, hy3:movefocus, u
        bind = $mod, $down, hy3:movefocus, d

        bind = $mod, a, hy3:raisefocus

        # move window
        bind = $mod + SHIFT, $left, hy3:movewindow, l
        bind = $mod + SHIFT, $right, hy3:movewindow, r
        bind = $mod + SHIFT, $up, hy3:movewindow, u
        bind = $mod + SHIFT, $down, hy3:movewindow, d

        # change layout
        bind = $mod, h, hy3:makegroup, h
        bind = $mod, v, hy3:makegroup, v

        # move workspaces
        bind = $mod + SHIFT, left, movecurrentworkspacetomonitor, l
        bind = $mod + SHIFT, right, movecurrentworkspacetomonitor, r
        bind = $mod + SHIFT, up, movecurrentworkspacetomonitor, u
        bind = $mod + SHIFT, down, movecurrentworkspacetomonitor, d

        # workspaces
        bind = , mouse:275, workspace, e+1
        bind = , mouse:276, workspace, e-1

        ${builtins.concatStringsSep "\n" (builtins.genList (
          x: let
            ws = toString (x + 1);
            key = toString (lib.mod (x + 1) 10);
          in ''
            bind = $mod, ${key}, workspace, ${ws}
            bind = $mod + SHIFT, ${key}, movetoworkspace, ${ws}
            bind = $mod + CTRL + SHIFT, ${key}, movetoworkspacesilent, ${ws}
          ''
        ) 10)}

        workspace = 9,monitor:HDMI-A-2
        workspace = 10,monitor:HDMI-A-2

        # window rules

        # league of legends
        windowrulev2 = nomaxsize, class:^(riotclientux.exe)$,title:^(Riot Client Main)$
        windowrulev2 = float, class:^(riotclientux.exe)$,title:^(Riot Client Main)$
        windowrulev2 = size 1540 850, class:^(riotclientux.exe)$,title:^(Riot Client Main)$
        windowrulev2 = center, class:^(riotclientux.exe)$,title:^(Riot Client Main)$

        windowrulev2 = nomaxsize, class:^(leagueclientux.exe)$,title:^(League of Legends)$
        windowrulev2 = float, class:^(leagueclientux.exe)$,title:^(League of Legends)$
        windowrulev2 = size 1280 720,class:^(leagueclientux.exe)$,title:^(League of Legends)$
        windowrulev2 = center, class:^(leagueclientux.exe)$,title:^(League of Legends)$

        windowrulev2 = float, class:^(league of legends.exe)$,title:^(League of Legends (TM) Client)$
        windowrulev2 = nomaxsize, class:^(league of legends.exe)$,title:^(League of Legends (TM) Client)$
        windowrulev2 = fullscreen, class:^(league of legends.exe)$,title:^(League of Legends (TM) Client)$

        # tor browser
        windowrulev2 = float, class:^(firefox)$,title:(Tor Browser)$
        windowrulev2 = center, class:^(firefox)$,title:(Tor Browser)$

        # todo exclude alacritty
        windowrulev2 = noborder, floating:1,class:^(?!Alacritty).*$

        # execs
        exec-once = ${pkgs.noisetorch}/bin/noisetorch -i
        exec-once = ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%
        # fix OpenURI
        exec-once = ${pkgs.bash}/bin/bash -c "${pkgs.systemd}/bin/systemctl --user import-environment PATH && ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gtk.service"
      '';
  };
}
