{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar-hyprland;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = [{
      layer = "top";
      position = "bottom";

      modules-left =
        [ "wlr/workspaces" "sway/workspaces" "hyprland/submap" "sway/mode" ];
      modules-center = [ ];
      modules-right = [
        "custom/mail"
        "mpris"
        "pulseaudio"
        "network#iface"
        "network#bandwidth"
        "cpu"
        "memory"
        "disk"
        "clock"
        "tray"
      ];

      "wlr/workspaces" = {
        sort-by-number = true;
        on-click = "activate";
        on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace m-1";
        on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace m+1";
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
      "custom/mail" = {
        format = "mail: {}";
        exec = "notmuch count tag:unread";
        exec-if =
          "bash -c 'notmuch new >/dev/null 2>/dev/null && notmuch count tag:unread | grep -v 0 >/dev/null'";
        interval = 30;
      };
      "mpris" = {
        player = "spotifyd";
        format-playing = "{title:.30}... - {artist:.20}...";
        format-paused = " ";
        format-stopped = " ";
      };
      "pulseaudio" = {
        format = "{volume}%";
        format-muted = "muted";
        tooltip = false;
        on-click = "${pkgs.playerctl}/bin/playerctl -p spotifyd play-pause";
        on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "network#iface" = {
        interval = 15;
        format = "{ifname}: {ipaddr}";
        format-wifi = "{ifname}: {ipaddr} ({essid}: {signalStrength})";
        tooltip-format = "{ifname}: {ipaddr} via {gwaddr}";
        tooltip-format-wifi =
          "{ifname}: {ipaddr} via {gwaddr} ({essid} {frequency}: {signalStrength})";
      };
      "network#bandwidth" = {
        interval = 5;
        format = "{bandwidthDownBytes} {bandwidthUpBytes}";
      };
      "cpu" = {
        interval = 2;
        format = "{usage:3}%";
        states = {
          warning = 75;
          critical = 90;
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
        interval = 1;
        format = "{:%d.%m.%Y %T}";
        tooltip = false;
      };
    }];
    style = ./style.css;
  };
}
