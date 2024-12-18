{ config, ... }:
let host = "127.0.0.1:5232";
in {
  containers."radicale" = {
    autoStart = true;

    bindMounts."data" = {
      hostPath = "/backed_up/var/lib/radicale";
      mountPoint = "/var/lib/radicale";
      isReadOnly = false;
    };

    config = {
      imports = [ ../../common/nixos-containers/basic-config.nix ];

      users = {
        users."radicale".uid = config.ids.uids.syncthing;
        groups."radicale".gid = config.ids.gids.syncthing;
      };

      services.radicale = {
        enable = true;
        settings = {
          server.hosts = [ host ];
          auth = {
            type = "htpasswd";
            htpasswd_filename = "/var/lib/radicale/htpasswd";
            htpasswd_encryption = "bcrypt";
          };
        };
      };
    };
  };

  services.nginx.virtualHosts."caldav.vaw-valentin.de".locations."/" = {
    proxyPass = "http://${host}/";
    proxyWebsockets = true;
  };
}
