{ config, lib, ... }: {
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      config = {
        enableACME = lib.mkDefault true;
        onlySSL = lib.mkDefault true;
        listenAddresses = lib.mkDefault [ "0.0.0.0" ];
      };
    });
  };

  config = lib.mkIf config.services.nginx.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    environment.persistence = {
      "/backed_up".directories = [ "/var/www" ];
      "/persist".directories = [ "/var/lib/acme" ];
    };

    services.nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };
  };
}
