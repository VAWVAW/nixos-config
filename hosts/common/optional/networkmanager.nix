{
  networking.networkmanager.enable = true;
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
