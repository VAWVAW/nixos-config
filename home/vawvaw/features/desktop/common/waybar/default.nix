{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = [{
      layer = "top";
      position = "bottom";

      modules-left = [
        "hyprland/workspaces"
        "sway/workspaces"
        "hyprland/submap"
        "sway/mode"
      ];
      modules-center = [ ];
      modules-right = [
        "custom/sync"
        "custom/mail"
        "mpris"
        "wireplumber"
        "network"
        "cpu"
        "battery"
        "memory"
        "disk"
        "clock"
        "tray"
        "group/power"
      ];

      "hyprland/workspaces" = {
        sort-by = "number";
        on-click = "activate";
        enable-bar-scroll = true;
      };
      "sway/workspaces" = {
        disable-scroll-wraparound = true;
        enable-bar-scroll = true;
      };
      "hyprland/submap" = {
        on-click = "${pkgs.hyprland}/bin/hyprctl dispatch submap reset";
        tooltip = false;
      };
      "sway/mode" = {
        on-click = "${pkgs.sway}/bin/swaymsg mode default";
        tooltip = false;
      };

      "custom/divera" = {
        return-type = "json";
        exec = ''
          ${pkgs.divera-status}/bin/divera-status -f $XDG_RUNTIME_DIR/secrets/divera-token -s 800,801,802 -o 804,802,801,800 -e -d '{{\"text\": \"{full_text} <span color=\\\"#{status_color}\\\">◼</span>\", \"class\": \"{status_name}\"}}' '';
      };
      "custom/sync" = {
        format = "{}";
        exec = ''
          ${pkgs.fd}/bin/fd -H .sync-conflict- ~/Documents | ${pkgs.gawk}/bin/awk 'BEGIN { ORS=""; num=0; print("{\"tooltip\": \"") }; { print($1); print("\n"); num+=1 }; END { printf("\",\"text\": \""); if (num == 0) print(""); else printf("sync-conflicts: %d", num); print("\"}\n") }' '';
        return-type = "json";
        interval = 600;
        on-click = "";
      };
      "custom/mail" = let signal = 1;
      in {
        inherit signal;
        interval = 300;
        exec =
          "${pkgs.notmuch}/bin/notmuch new >/dev/null 2>/dev/null; ${pkgs.notmuch}/bin/notmuch count tag:unread | ${pkgs.gnused}/bin/sed -E 's/(.+)/mail: \\1/' | ${pkgs.gnugrep}/bin/grep -v 'mail: 0'";
        on-click = "pkill -SIGRTMIN+${toString signal} .waybar-wrapped";
        tooltip = false;
      };
      "mpris" = {
        player = "spotifyd";
        format-playing = "{title} - {artist}";
        format-paused = " ";
        format-stopped = " ";
        title-len = 32;
        artist-len = 20;
        tooltip-format-playing =
          "{player}: {title} - {artist} - {album} ({length})";
      };
      "wireplumber" = {
        format = "{volume}%";
        format-muted = "muted";
        tooltip = false;
        on-click = "${pkgs.playerctl}/bin/playerctl -p spotifyd play-pause";
        on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "network" = {
        interval = 5;
        format =
          "<span color='#00ff00'>{ifname}: {ipaddr}</span>  {bandwidthDownBytes} {bandwidthUpBytes}";
        format-wifi =
          "<span color='#00ff00'>{ifname}: {ipaddr} ({essid})</span>  {bandwidthDownBytes} {bandwidthUpBytes}";
        format-disconnected = "no connection";
        tooltip-format = ''
          {ipaddr}/{netmask} via {gwaddr}
          Down: {bandwidthDownBits} Up: {bandwidthUpBits}'';
        tooltip-format-wifi = ''
          {ipaddr}/{netmask} via {gwaddr}
          {essid} ({frequency}): {signalStrength}%
          Down: {bandwidthDownBits} Up: {bandwidthUpBits}'';
        tooltip-format-disconnected = " ";
      };
      "cpu" = {
        interval = 5;
        format = "{usage:3}%";
        states = {
          warning = 75;
          critical = 90;
        };
      };
      "battery" = {
        interval = 30;
        format = "{capacity}%{time}";
        tooltip-format = "{timeTo} ({power:.3}W)";
        format-time = "({H}:{m})";
        full-at = 80;
        states = {
          warning = 30;
          critical = 15;
        };

      };
      "memory" = {
        interval = 10;
        format = "{used:0.1f}G";
        tooltip-format = "{used}GiB used out of {total}GiB ({percentage}%)";
        states = {
          warning = 75;
          critical = 90;
        };
      };
      "disk" = {
        format = "{free}";
        states = {
          warning = 85;
          critical = 95;
        };
      };
      "clock" = {
        interval = 5;
        format = "{:%d.%m.%Y %T}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "left";
          on-scroll = 1;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ffffff' background='#44e'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-middle = "mode";
          on-click = "shift_down";
          on-scroll-up = "shift_down";
          on-click-right = "shift_up";
          on-scroll-down = "shift_up";
        };
      };
      "group/power" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 100;
          trasition-left-to-right = true;
          children-class = "drawer-power";
        };
        modules =
          [ "idle_inhibitor" "custom/shutdown" "custom/reboot" "custom/lock" ];
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󰐯";
          deactivated = "󱠍";
        };
      };
      "custom/lock" = {
        format = "";
        tooltip = false;
        on-click =
          "${pkgs.swaylock}/bin/swaylock && systemctl --user restart waybar";
      };
      "custom/shutdown" = {
        format = "⏻";
        tooltip = false;
        on-click = "systemctl poweroff";
      };
      "custom/reboot" = {
        format = "⏼";
        tooltip = false;
        on-click = "systemctl reboot";

      };
    }];

    style = let inherit (config.desktop) theme;
    in builtins.replaceStrings [
      "$focused_text"
      "$focused_background"
      "$focused_border"

      "$secondary_text"
      "$secondary_background"
      "$secondary_border"

      "$unfocused_text"
      "$unfocused_background"
      "$unfocused_border"

      "$urgent_text"
      "$urgent_background"
      "$urgent_border"
    ] [
      theme.focused.text
      theme.focused.background
      theme.focused.border

      theme.secondary.text
      theme.secondary.background
      theme.secondary.border

      theme.unfocused.text
      theme.unfocused.background
      theme.unfocused.border

      theme.urgent.text
      theme.urgent.background
      theme.urgent.border
    ] (builtins.readFile ./style.css);
  };
}
