let ipv4 = "192.168.2.20";
in {
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    wait-online.extraArgs = [ "--interface=enu1u1u1:routable" ];

    networks."40-enu1u1u1" = {
      matchConfig.Name = "enu1u1u1";
      address = [ "${ipv4}/24" ];
      routes = [{ Gateway = "192.168.2.1"; }];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # enable resolved in initrd
  boot.initrd.systemd.contents."/etc/systemd/resolved.conf.d/override.conf".text =
    ''
      [Resolve]
      DNS=1.1.1.1
      FallbackDNS=8.8.8.8

      DNSStubListenerExtra=${ipv4}
    '';
}
