{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/persist" = { directories = [ "/var/www" ]; };

  environment.persistence."/local_persist" = {
    directories = [ "/var/lib/acme" ];
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
            addr = "127.0.0.1";
            port = 443;
            ssl = true;
          }
        ];

        root = "/var/www/server";
      };
    };
  };
}
