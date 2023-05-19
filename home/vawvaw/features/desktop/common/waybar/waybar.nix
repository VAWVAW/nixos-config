{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      postPatch = ''
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
      '';
    });
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = [{
      layer = "top";
      position = "bottom";

      modules-left = [
        "wlr/workspaces"
        "sway/workspaces"
        "hyprland/submap"
        "sway/mode"
      ];
      modules-center = [];
      modules-right = [
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
        on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace -1";
        on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace +1";
      };
      "hyprland/submap" = {
        on-click = "${pkgs.hyprland}/bin/hyprctl dispatch submap reset";
        tooltip = false;
      };
      "sway/mode" = {
        on-click = "${pkgs.sway}/bin/swaymsg mode default";
        tooltip = false;
      };

      "mpris" = {
        player = "spotifyd";
        format-playing = "{title:.30} - {artist:.20}";
        format-paused = " ";
        format-stopped = " ";
      };
      "pulseaudio" = {
        format = "{volume}%";
        format-muted = "muted";
        tooltip = false;
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "network#iface" = {
        interval = 15;
        format = "{ifname}: {ipaddr}";
        format-wifi = "{ifname}: {ipaddr} ({essid}: {signalStrength})";
        tooltip-format = "{ifname}: {ipaddr} via {gwaddr}";
        tooltip-format-wifi = "{ifname}: {ipaddr} via {gwaddr} ({essid} {frequency}: {signalStrength})";
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
