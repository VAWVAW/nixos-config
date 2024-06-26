{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence = {
    "/backed_up".directories = [ "/var/www" ];
    "/persist".directories = [ "/var/lib/acme" ];
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "server.vaw-valentin.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];

        root = "/var/www/server";

        # `nix-shell -p simple-http-server --run simple-http-server -p 8080 -ui -l 5000000000000000000`
        #
        # locations."/upload/" = {
        #   proxyPass = "http://localhost:8080/";
        #   extraConfig = ''
        #     client_max_body_size 10G;
        #   '';
        # };
      };
      "caldav.vaw-valentin.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        locations."/" = {
          proxyPass = "http://${
              builtins.head
              config.containers.radicale.config.services.radicale.settings.server.hosts
            }/";
          proxyWebsockets = true;
        };
      };
      "ntfy.nlih.de" = {
        enableACME = true;
        forceSSL = true;
        listen = [{
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }];

        locations."/" = {
          proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}/";
          proxyWebsockets = true;
        };
      };
    };
  };
}
