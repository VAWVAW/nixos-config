{ lib, config, ... }: {
  imports = [ ../../common/optional/unit-fail-notification.nix ];
  environment.persistence."/persist".directories = [ "/var/lib/borg" ];

  users = {
    users."borg" = {
      isSystemUser = true;
      group = "borg";
      extraGroups = [ config.users.users."nginx".group ];
      home = "/var/lib/borg";
      uid = config.ids.uids.syncthing;
    };
    groups."borg".gid = config.ids.gids.syncthing;
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
        exclude = [ "var/lib/syncthing/data/Documents/**/.git" ];

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
    };
  };

  systemd = {
    services = {
      "borgbackup-job-local" = {
        serviceConfig = {
          Restart = lib.mkForce "on-failure";
          RestartSec = lib.mkForce 60;
        };

        onFailure = [ "unit-status-notification@%n.service" ];
      };
    };
  };
}