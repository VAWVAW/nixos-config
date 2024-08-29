{ config, ... }: {
  containers."radicale" = let
    address = "192.168.101.11";
    port = 5232;
  in {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.101.10";
    localAddress = address;

    bindMounts."data" = {
      hostPath = "/backed_up/var/lib/radicale";
      mountPoint = "/var/lib/radicale";
      isReadOnly = false;
    };

    config = {
      imports = [ ../../common/nixos-containers/basic-config.nix ];

      networking.firewall.allowedTCPPorts = [ port ];

      users = {
        users."radicale".uid = config.ids.uids.syncthing;
        groups."radicale".gid = config.ids.gids.syncthing;
      };

      services.radicale = {
        enable = true;
        settings = {
          server.hosts = [ "${address}:${builtins.toString port}" ];
          auth = {
            type = "htpasswd";
            htpasswd_filename = "/var/lib/radicale/htpasswd";
            htpasswd_encryption = "bcrypt";
          };
        };
      };
    };
  };
}
