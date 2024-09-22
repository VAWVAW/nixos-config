{
  networking.useDHCP = false;
  networking.nameservers = [ "192.168.2.20" ];

  systemd.network = {
    enable = true;
    wait-online.ignoredInterfaces = [ "wlp9s0" ];
    networks."40-eno1" = {
      matchConfig.Name = "eno1";
      address = [ "192.168.2.10/24" ];
      routes = [{ Gateway = "192.168.2.1"; }];
    };
    links."50-eth" = {
      matchConfig.Type = "ether";
      linkConfig = {
        MACAddressPolicy = "persistent";
        WakeOnLan = "magic";
        NamePolicy = "onboard";
      };
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [ ];
  };
}
