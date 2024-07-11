{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    wait-online.extraArgs = [ "--interface=enu1u1u1:routable" ];

    networks."40-enu1u1u1" = {
      matchConfig.Name = "enu1u1u1";
      address = [ "192.168.2.20/24" ];
      routes = [{ routeConfig.Gateway = "192.168.2.1"; }];
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
