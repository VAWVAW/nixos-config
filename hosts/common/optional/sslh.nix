{ config, lib, ... }:
let
  getInterface = name: config.networking.interfaces.${name};
  addresses = lib.lists.flatten (map (name:
    map (a: a.address)
    ((getInterface name).ipv4.addresses ++ (getInterface name).ipv6.addresses))
    (lib.attrNames config.networking.interfaces));
in {
  networking.firewall.allowedTCPPorts = [ config.services.sslh.port ];

  services.sslh = {
    enable = true;
    port = 443;
    listenAddresses = lib.mkDefault addresses;

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
