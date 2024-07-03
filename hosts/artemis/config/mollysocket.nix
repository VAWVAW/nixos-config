let
  host = "127.0.0.1";
  port = 8020;
in {
  environment.persistence."/persist".directories =
    [ "/var/lib/private/mollysocket" ];

  system.activationScripts."setup_private" = ''
    mkdir -p /var/lib/private
    chmod 700 /var/lib/private
  '';

  services.mollysocket = {
    enable = true;
    settings = {
      inherit host port;
      webserver = true;
      allowed_endpoints = [ "https://ntfy.nlih.de" ];
    };
  };

  services.nginx.virtualHosts."mollysocket.nlih.de" = {
    enableACME = true;
    forceSSL = true;
    listen = [{
      addr = "0.0.0.0";
      port = 443;
      ssl = true;
    }];

    locations."/" = {
      proxyPass = "http://${host}:${builtins.toString port}/";
      proxyWebsockets = true;
    };
  };
}
