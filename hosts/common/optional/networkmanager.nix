{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}
