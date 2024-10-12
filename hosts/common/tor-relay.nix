{ config, lib, ... }: {
  config = lib.mkIf config.services.tor.relay.enable {
    services.tor = {
      enable = true;
      openFirewall = true;

      relay.role = "relay";

      settings = {
        Nickname = "vaw";
        ContactInfo = "tor-relay@vaw-valentin.de";
        ORPort = [ 9001 ];

        RelayBandwidthRate = "12 MBytes";
        RelayBandwidthBurst = "2 GBits";
        AccountingMax = "1 TBytes";
        AccountingStart = "day 00:00";
      };
    };

    environment.persistence."/persist".directories =
      [ config.services.tor.settings.DataDirectory ];
  };
}
