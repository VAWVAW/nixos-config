{ pkgs, lib, ... }: {
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
      {
        name = "Philips Consumer Electronics Company PHL 243V5 UK01639008163";
        position = "0 0";
        workspaces = [ "1" ];
      }
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
}
