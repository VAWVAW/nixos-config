{ config, pkgs, lib, ... }:
let
  sound_script = pkgs.writeShellScript "dunst-sound" ''
    if [[ "$DUNST_APP_NAME" =~ ^(spotifyd|discord)$ ]]; then
      exit
    fi

    if [ "$DUNST_URGENCY" = "CRITICAL" ]; then
      ${pkgs.sox}/bin/play -q ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga
    else
      ${pkgs.sox}/bin/play -q ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/dialog-warning.oga
    fi
  '';
in {

  config = lib.mkIf config.services.dunst.enable {
    desktop.keybinds.binds = [{
      mods = [ "Super" ];
      key = "c";
      command = "${pkgs.dunst}/bin/dunstctl context";
    }];

    services.dunst = {
      settings = {
        global = {
          follow = "none";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "10x20";
          scale = 0;
          notification_limit = 0;

          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;

          indicate_hidden = "yes";
          transparency = 0;
          separator_height = 8;
          padding = 10;
          text_icon_padding = 0;
          frame_width = 0;
          frame_color = "#888888";
          separator_color = "#ffffff00";
          sort = "yes";

          font = "Monospace 10";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";

          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;

          dmenu =
            "${pkgs.bemenu}/bin/bemenu -p dunst -l 20 ${config.home.sessionVariables.BEMENU_OPTS}";
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
          title = "dunst";
          class = "dunst";
          corner_radius = 8;
          ignore_dbusclose = false;
          force_xwayland = false;

          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };
        urgency_low = {
          background = "#444444";
          foreground = "#dddddd";
          timeout = 5;
        };
        urgency_normal = {
          background = "#444444";
          foreground = "#dddddd";
          timeout = 5;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 5;
        };
        play_sound.script = "${sound_script}";
      };
    };
  };
}
