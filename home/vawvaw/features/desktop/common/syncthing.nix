{
  services.syncthing.enable = true;

  home.persistence."/persist/home/vawvaw".directories =
    [ ".config/syncthing" ];
}
