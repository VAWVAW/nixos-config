{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "00_default" = {
        serverName = "default.nlih.de";
        onlySSL = false;
        addSSL = true;

        globalRedirect = "server.vaw-valentin.de";
      };
      "server.vaw-valentin.de" = {
        onlySSL = false;
        forceSSL = true;

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
    };
  };
}
