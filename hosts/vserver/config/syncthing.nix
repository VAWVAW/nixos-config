{ config, ... }: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    dataDir = "/var/lib/syncthing/data";
    configDir = "/var/lib/syncthing/config";

    settings.options = {
      localAnnounceEnabled = false;
    };
  };

  environment.persistence."/backed_up".directories =
    [ config.services.syncthing.dataDir ];
  environment.persistence."/persist".directories =
    [ config.services.syncthing.configDir ];
}