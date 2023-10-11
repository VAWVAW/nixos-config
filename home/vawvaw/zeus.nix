{
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

  desktop.screens = [{
    name = "BOE 0x0BCA Unknown";
    size = "2256x1504";
    scale = "1.6";
  }];

  wayland.windowManager.sway = {
    colorscheme = "blue";
    config = {
      keybindings = {
        "XF86AudioMedia" = "input type:touchpad events toggle enabled disabled";
      };
      bars = lib.mkForce [{
        statusCommand =
          "/home/vawvaw/Documents/coding/rust/swayblocks/target/release/swayblocks";
        trayOutput = "none";
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
