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

  services.nginx.virtualHosts."mollysocket.nlih.de".locations."/" = {
    proxyPass = "http://${host}:${builtins.toString port}/";
    proxyWebsockets = true;
  };
}
