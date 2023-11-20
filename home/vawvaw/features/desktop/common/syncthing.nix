{
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  home.persistence."/persist/home/vawvaw" = {
    directories = [ ".config/syncthing" ];
    files = [ ".config/syncthingtray.ini" ];
  };
}
