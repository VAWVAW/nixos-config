{ config, lib, ... }: {
  config = lib.mkIf config.services.syncthing.enable {
    home.persistence."/persist/home/vaw" = {
      directories = [{
        directory = ".config/syncthing";
        method = "symlink";
      }];
      files = [ ".config/syncthingtray.ini" ];
    };

    services.syncthing.tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };
}
