{ config, lib, ... }: {
  config = lib.mkIf config.networking.networkmanager.enable {
    systemd.services."NetworkManager-wait-online".enable = false;

    environment.persistence."/persist" = {
      directories = [ "/etc/NetworkManager/system-connections" ];
    };
  };
}
