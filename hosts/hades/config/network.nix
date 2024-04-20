{
  networking = {
    hosts = {
      "192.168.2.11" = [ "athena" ];
      "192.168.2.20" = [ "nyx" ];
    };

    nameservers = [ "192.168.2.20" ];

    nat.externalInterface = "eno1";
    interfaces."eno1" = {
      wakeOnLan.enable = true;
      ipv4 = {
        addresses = [{
          address = "192.168.2.10";
          prefixLength = 24;
        }];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "192.168.2.1";
          }
          {
            address = "192.168.2.0";
            prefixLength = 24;
          }
        ];
      };
    };
    dhcpcd.enable = false;
    useNetworkd = true;
  };

  systemd.network = {
    wait-online.ignoredInterfaces = [ "wlp9s0" ];
    links."50-eth" = {
      matchConfig.Type = "ether";
      linkConfig = {
        MACAddressPolicy = "persistent";
        WakeOnLan = "magic";
        NamePolicy = "onboard";
      };
    };
  };

}
