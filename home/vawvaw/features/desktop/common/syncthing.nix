{
  services.syncthing.enable = true;

  home.persistence."/local_persist/home/vawvaw".directories =
    [ ".config/syncthing" ];
}
