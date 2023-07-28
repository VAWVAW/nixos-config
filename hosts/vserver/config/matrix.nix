{ pkgs, lib, config, ... }:
let
  mx-discord-home = "/var/lib/mx-discord";
  discord-config = pkgs.writeText "mx-discord-config"
    (lib.generators.toYAML { } {
      bridge = {
        port = 8080;
        bindAddress = "localhost";
        domain = "vaw-valentin.de";
        homeserverUrl = "https://matrix.vaw-valentin.de";
        displayname = "Discord Puppet Bridge";
        enableGroupSync = true;
      };
      presence = {
        enabled = true;
        interval = 500;
      };
      provisioning.whitelist = [ "@vawvaw:vaw-valentin.de" ];
      relay.whitelist = [ "@vawvaw:vaw-valentin.de" ];
      selfService.whitelist = [ "@vawvaw:vaw-valentin.de" ];
      namePatterns = {
        user = ":name";
        userOverride = ":displayname";
        room = ":name";
        group = ":name";
      };
      database.connString =
        "postgres://matrix-discord:discord@localhost/matrix-discord?sslmode=disable";
      logging = {
        console = "info";
        lineDateFormat = "MMM-D HH:mm:ss.SSS";
      };
    });
in {
  imports = [ ./nginx.nix ];

  sops.secrets.synapse_shared_secret = {
    format = "binary";
    sopsFile = ./synapse_shared_secret;
    owner = "matrix-synapse";
  };

  environment.persistence."/persist".directories = [
    config.services.postgresql.dataDir
    config.services.matrix-synapse.dataDir
    mx-discord-home
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  users.groups.matrix-discord = { };
  users.users.matrix-discord = {
    isSystemUser = true;
    group = "matrix-discord";
    home = mx-discord-home;
  };

  # systemd.services.matrix-discord = {
  #   description = "mx-discord-puppet bridge";
  #   wantedBy = [ "multiuser.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "matrix-discord";
  #     Group = "matrix-discord";
  #     WorkingDirectory = mx-discord-home;
  #     Restart = "on-failure";
  #     ExecStart = ''
  #       ${pkgs.mx-puppet-discord}/bin/mx-puppet-discord -f ${mx-discord-home}/registration.yaml -c ${discord-config}
  #     '';
  #   };
  # };

  services = {
    postgresql = {
      enable = true;
      initialScript = pkgs.writeText "synapse-init.sql" ''
        CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
        CREATE ROLE "matrix-discord" WITH LOGIN PASSWORD 'discord';
        CREATE DATABASE "matrix-discord" WITH OWNER "matrix-discord"
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      '';
    };

    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "matrix.vaw-valentin.de" = {
          enableACME = true;
          forceSSL = true;
          inherit (config.services.nginx.virtualHosts."server.vaw-valentin.de")
            listen;

          root = "/var/www/matrix";
          locations."/_matrix".proxyPass = "http://[::1]:8008";
          locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        };
      };
    };

    matrix-synapse = {
      enable = true;
      settings = {
        server_name = "vaw-valentin.de";
        listeners = [{
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = true;
          }];
        }];
        app_service_config_files = [ "${mx-discord-home}/registration.yaml" ];
        enable_group_creation = true;
      };
      extraConfigFiles = [ config.sops.secrets.synapse_shared_secret.path ];
    };
  };
}
