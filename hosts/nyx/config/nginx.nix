{
  services.nginx = {
    enable = true;
    virtualHosts."home.vaw-valentin.de" = {
      onlySSL = false;
      forceSSL = true;

      root = "/var/www/server";
    };
  };
}
