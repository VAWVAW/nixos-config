{ pkgs, lib, config, ... }:
let
  mouse = "4119:24578:HID_1017:6002_Mouse";
  first_screen = {
    name = "Philips Consumer Electronics Company PHL 243V5 UK01639008163";
    position = "0 0";
    workspaces = [ "1" ];
  };
in {
  imports = [
    ../common
    ../desktop

    ../desktop/optional/sway.nix
    ../desktop/optional/hyprland.nix
    ../desktop/optional/swayidle.nix
    ../desktop/optional/waybar

    ../desktop/optional/steam.nix
    ../desktop/optional/lutris.nix
    ../desktop/optional/minecraft.nix
  ];

  services.spotifyd.settings.global.device_name = "hades_spotifyd";

  home = {
    keyboard.options = [ "altwin:menu_win" ];
    sessionVariables.NVK_I_WANT_A_BROKEN_VULKAN_DRIVER = "1";
  };

  programs = {
    firejail.wrappedBinaries = {
      signal-desktop.executable = lib.mkForce
        "${pkgs.signal-desktop}/bin/signal-desktop --use-gl=desktop";
    };

    # use system dns resolver (should be athena)
    firefox.profiles."default".settings."network.trr.mode" = lib.mkForce 5;
  };

  desktop = {
    screens = [
      first_screen
      {
        name = "Philips Consumer Electronics Company PHL 223V5 ZVC1532001649";
        position = "1920 65";
        workspaces = [ "9" "10" ];
      }
    ];
    startup_commands = [
      "${pkgs.noisetorch}/bin/noisetorch -i"
      "discord"
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%'"
    ];
  };

  wayland.windowManager.sway = {
    config = {
      seat."*".hide_cursor = lib.mkForce "0";
      keybindings."Mod4+Ctrl+Shift+Tab" = lib.mkForce
        (builtins.replaceStrings [ "\n" ] [ "; " ] ''
          output '${first_screen.name}' pos 5000 5000
          input 'type:keyboard' xkb_options 'altwin:menu_win,custom:qwertz_y_z'
          mode disabled'');
      modes."disabled"."Mod4+Ctrl+Shift+Tab" = lib.mkForce
        (builtins.replaceStrings [ "\n" ] [ "; " ] ''
          output '${first_screen.name}' pos ${first_screen.position}
          input 'type:keyboard' xkb_options '${
            config.wayland.windowManager.sway.config.input."type:keyboard".xkb_options
          }'
          mode default'');
    };
    extraConfig = ''
      # bind mouse
      bindsym --input-device=${mouse} --whole-window button8 workspace next
      bindsym --input-device=${mouse} --whole-window button9 workspace prev

      bindcode 152 exec --no-startup-id ${pkgs.sway}/bin/swaymsg seat - cursor press button3
      bindcode --release 152 exec --no-startup-id ${pkgs.sway}/bin/swaymsg seat - cursor release button3

      # workspace layout
      workspace --no-auto-back-and-forth 10; layout stacking; workspace --no-auto-back-and-forth 1

    '';
  };
}
