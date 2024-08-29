{ config, pkgs, lib, ... }: {
  options.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.desktop.enable {
    security = {
      pam.services = {
        swaylock = { };
        hyprlock = { };
      };
      apparmor.enable = true;
    };

    fonts = {
      packages = with pkgs; [ corefonts font-awesome ];
      enableDefaultPackages = true;
    };

    programs.firejail.enable = true;
    programs.dconf.enable = true;

    services.pipewire.enable = true;

    hardware.opengl.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
