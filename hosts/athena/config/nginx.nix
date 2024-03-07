{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/backed_up" = { directories = [ "/var/www" ]; };

  environment.persistence."/persist" = { directories = [ "/var/lib/acme" ]; };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "home.vaw-valentin.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 443;
            ssl = true;
          }
        ];

        root = "/var/www/server";
      };
      "caldav.vaw-valentin.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 443;
            ssl = true;
          }
        ];

        locations."/" = {
          proxyPass =
            "http://${builtins.head config.containers.radicale.config.services.radicale.settings.server.hosts}/";
          proxyWebsockets = true;
        };
      };
      "divera.nlih.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 443;
            ssl = true;
          }
        ];

        root = "/var/www/divera/html";
        basicAuthFile = "/var/www/divera/auth/htpasswd";
        locations."/api/" = {
          proxyPass =
            "http://localhost:8000/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
