{ lib, config, pkgs, ... }: {
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/common/syncthing.nix
    ./features/desktop/common/obsidian.nix
  ];

  services.spotifyd.settings.global.device_name = "zeus_spotifyd";

  battery = {
    enable = true;
    name = "BAT1";
  };

  home.shellAliases = {
    nswitch =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild switch --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
    nboot =
      "sudo mount /boot -o remount,rw && sudo nixos-rebuild boot --flake /home/vawvaw/Documents/nixos-config# && sudo mount /boot -o remount";
  };

  programs = {
    firejail.wrappedBinaries.signal-desktop.executable =
      lib.mkForce "${pkgs.signal-desktop}/bin/signal-desktop";
    firejail.wrappedBinaries.mattermost-desktop.executable =
      lib.mkForce "${pkgs.mattermost-desktop}/bin/mattermost-desktop";

    alacritty.settings.font.size = lib.mkForce 8.0;
  };

  desktop = {
    screens = [{
      name = "BOE 0x0BCA Unknown";
      size = "2256x1504";
      scale = "1.5";
    }];
    startup_commands = [
      "${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%; ${pkgs.light}/bin/light -S 10%'"
    ];
  };

  wayland.windowManager.sway = {
    colorscheme = "blue";
    config = {
      keybindings = {
        "XF86AudioMedia" = "input type:touchpad events toggle enabled disabled";
      };
      bars = lib.mkForce [{
        statusCommand =
          "/home/vawvaw/Documents/coding/rust/swayblocks/target/release/swayblocks";
        trayOutput = "*";
        position = "bottom";
        colors = let inherit (config.wayland.windowManager.sway.config) colors;
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
    };
  };

}
