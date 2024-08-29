{ config, lib, ... }: {
  options.services.syncthing-container.enable =
    lib.mkEnableOption "syncthing container";

  config = lib.mkIf config.services.syncthing-container.enable {
    containers."syncthing" = let
      dataDir = "/var/lib/syncthing/data";
      configDir = "/var/lib/syncthing/config";
    in {
      autoStart = true;
      bindMounts = {
        "data" = {
          hostPath = "/backed_up${dataDir}";
          mountPoint = dataDir;
          isReadOnly = false;
        };
        "config" = {
          hostPath = "/persist${configDir}";
          mountPoint = configDir;
          isReadOnly = false;
        };
      };

      config = {
        imports = [ ./nixos-containers/basic-config.nix ];

        services.syncthing = {
          inherit dataDir configDir;

          enable = true;
          openDefaultPorts = true;

          overrideDevices = false;
          overrideFolders = false;

          settings.options.localAnnounceEnabled = false;
        };
      };
    };

    environment.persistence."/backed_up".directories =
      [ config.services."syncthing".dataDir ];
    environment.persistence."/persist".directories =
      [ config.services."syncthing".configDir ];
  };
}
