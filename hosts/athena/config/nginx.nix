{ config, ... }: {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "home.vaw-valentin.de" = {
        onlySSL = false;
        forceSSL = true;
        root = "/var/www/server";
      };
      "caldav.vaw-valentin.de" = {
        onlySSL = false;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${
              builtins.head
              config.containers.radicale.config.services.radicale.settings.server.hosts
            }/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
