{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@vaw-valentin.de";
  };

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
      "home.vaw-valentin.de" = {
        forceSSL = true;
        listen = [
          {
            addr = "192.168.2.101";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 80;
          }
          {
            addr = "127.0.0.1";
            port = 443;
            ssl = true;
          }
        ];
        enableACME = true;
        root = "/var/www/home";
      };
    };
  };
}
