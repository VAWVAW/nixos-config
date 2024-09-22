{ lib, ... }: {
  networking.firewall.allowedUDPPorts = [
    # dns
    53
    # dhcp
    67
  ];

  services.resolved.enable = false;

  containers."adguardhome" = {
    autoStart = true;

    privateNetwork = false;

    config = {
      imports = [ ../../common/nixos-containers/basic-config.nix ];
      networking.firewall.enable = lib.mkForce false;

      services.adguardhome = {
        enable = true;
        mutableSettings = true;
        settings = {
          http.address = "127.0.0.1:3000";
          users = [{
            name = "vaw";
            password =
              "$2y$05$1nsejLD2ESJ8O14pVQ6Df.xa1ggrcjoCNnP.18GGrtrzpN5M8eQ2i";
          }];
          dns = {
            bind_hosts = [ "0.0.0.0" ];
            port = 53;

            ratelimit = 0;

            upstream_dns = [
              "https://dns10.quad9.net/dns-query"
              "https://doh.mullvad.net/dns-query"
            ];
            fallback_dns = [ "https://dns.cloudflare.com/dns-query" ];
            bootstrap_dns = [
              # quad9
              "https://9.9.9.10/dns-query"
              "https://149.112.112.10/dns-query"
              "https://[2620:fe::10]/dns-query"
              "https://[2620:fe::fe:10]/dns-query"
              # cloudflare
              "https://1.1.1.1/dns-query"
              "https://[2606:4700:4700::1111]/dns-query"
            ];
            upstream_mode = "load_balance";
            cache_size = 4194304;
            cache_ttl_min = 60;
          };
          dhcp = {
            enabled = true;
            interface_name = "enu1u1u1";
            local_domain_name = "lan";
            dhcpv4 = {
              gateway_ip = "192.168.2.1";
              subnet_mask = "255.255.255.0";
              range_start = "192.168.2.40";
              range_end = "192.168.2.240";
              lease_duration = 86400;
            };
            dhcpv6 = {
              range_start = "2003:ea:c734:97b9::";
              lease_duration = 86400;
            };
          };
        };
      };
    };
  };
}
