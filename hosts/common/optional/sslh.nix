{ config, lib, ... }: {
  networking.firewall.allowedTCPPorts = [ config.services.sslh.port ];

  services.sslh = {
    enable = true;
    port = 443;
    listenAddresses = lib.mkDefault null;

    settings = {
      transparent = true;
      protocols = [
        {
          name = "ssh";
          service = "ssh";
          host = "localhost";
          port = "22";
        }
        {
          name = "tls";
          host = "localhost";
          port = "443";
        }
      ];
    };
  };
}
