{ pkgs, lib, config, ... }:
let configPath = "/var/lib/netcup-ddns";
in {
  imports = [ ../default.nix ];

  virtualisation.oci-containers.containers.netcup-ddns = {
    image = "localhost/netcup-dynamic-dns:latest";
    imageFile = import ./docker.nix { inherit pkgs; };

    autoStart = false;

    volumes = [ "${configPath}:/config" ];
  };

  systemd = {
    services.podman-netcup-ddns = {
      after = [ "network.target" ];
      preStart = lib.mkAfter ''
        set +e
        mkdir -p ${configPath}
        cp ${config.sops.secrets.netcup-ddns.path} ${configPath}/config.php
      '';
      postStop = lib.mkAfter ''
        rm -rf ${configPath}
      '';

      serviceConfig = { Restart = lib.mkForce "on-failure"; };
    };
    timers.podman-netcup-ddns = {
      wantedBy = [ "timers.target" ];
      description = "Update netcup dns entry";

      timerConfig = {
        # each day at 3, 6 and 9 am
        OnCalendar = "3,6,9:00";
        Persistent = true;
      };
    };
  };

  sops.secrets.netcup-ddns = {
    format = "binary";
    sopsFile = ./config.php.secret;
  };
}
