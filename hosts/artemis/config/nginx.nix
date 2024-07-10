{ lib, ... }: {
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      config = {
        enableACME = lib.mkDefault true;
        onlySSL = lib.mkDefault true;
        listenAddresses = lib.mkDefault [ "0.0.0.0" ];
      };
    });
  };

  config = {
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
  };
}
