{
  networking.useDHCP = false;

  systemd.network = {
    enable = true;
    networks."40-enp3s0" = {
      matchConfig.Name = "enp3s0";
      address = [ "152.53.18.121/22" ];
      routes = [{ routeConfig.Gateway = "152.53.16.1"; }];
    };
  };

  services.sslh.listenAddresses = [ "152.53.18.121" ];

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    extraConfig = ''
      DNS=194.242.2.2#dns.mullvad.net 9.9.9.10#dns10.quad9.net
    '';
    fallbackDns = [
      # quad9
      "149.112.112.10"
      "2620:fe::10"
      # cloudflare
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };
}
