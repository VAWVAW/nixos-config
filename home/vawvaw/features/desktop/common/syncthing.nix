{
  home.persistence."/persist/home/vawvaw" = {
    directories = [{
      directory = ".config/syncthing";
      method = "symlink";
    }];
    files = [ ".config/syncthingtray.ini" ];
  };

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };
}
