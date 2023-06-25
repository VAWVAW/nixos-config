{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.persistence."/local_persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager/seen-bssids"
    ];
    files = [
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/timestamps"
    ];
  };
}
