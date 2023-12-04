{ lib, config, pkgs, ... }: {
  imports = [ ../../common/optional/unit-fail-notification.nix ];
  environment.persistence."/persist".directories = [ "/var/lib/borg" ];

  users = {
    users."borg" = {
      isSystemUser = true;
      group = "borg";
      home = "/var/lib/borg";
      uid = config.ids.uids.syncthing;
    };
    groups."borg".gid = config.ids.gids.syncthing;
  };

  sops.secrets."borg-andorra" = {
    sopsFile = ./secrets.yaml;

    mode = "0400";
    owner = config.users.users."borg".name;
  };

  services.borgbackup = {
    repos."system" = {
      path = "/backup/borgbackup";
      user = "borg";
      group = "borg";
      authorizedKeys =
        [ (lib.readFile ../../common/users/vawvaw/home/pubkey_ssh.txt) ];
    };
    jobs = let
      default = {
        user = "borg";
        group = "borg";
        persistentTimer = true;

        paths = [ "/backed_up" ];

        archiveBaseName = "data";
        compression = "lz4";

        prune.keep = {
          within = "1d";
          daily = 7;
          weekly = 4;
          monthly = -1;
        };
      };
    in {
      "local" = default // {
        repo = "/backup/borgbackup";
        encryption.mode = "none";
      };
      "andorra" = default // {
        startAt = "weekly";

        environment."BORG_RSH" =
          "${pkgs.openssh}/bin/ssh -i /persist/etc/ssh/ssh_borg_athena_key";
        repo = "vw7335fu@andorra.imp.fu-berlin.de:backup";

        encryption.mode = "repokey-blake2";
        encryption.passCommand = "${pkgs.coreutils}/bin/cat ${
            config.sops.secrets."borg-andorra".path
          }";
      };
    };
  };

  systemd.services = {
    "borgbackup-job-local" = {
      serviceConfig = {
        Restart = lib.mkForce "on-failure";
        RestartSec = lib.mkForce 15;
      };

      onFailure = [ "unit-status-notification@%n.service" ];
    };
    "borgbackup-job-andorra" = {
      serviceConfig = {
        Restart = lib.mkForce "on-failure";
        RestartSec = lib.mkForce 15;
      };

      onFailure = [ "unit-status-notification@%n.service" ];
    };
  };
}
