{ lib, ... }: {
  imports = [ ../../common/optional/unit-fail-notification.nix ];
  environment.persistence."/persist".directories = [ "/var/lib/borg" ];

  users = {
    groups."borg" = { };
    users."borg" = {
      isSystemUser = true;
      group = "borg";
      home = "/var/lib/borg";
    };
    users."syncthing".homeMode = "750";
  };

  services.borgbackup = {
    repos."system" = {
      path = "/backup/borgbackup";
      user = "borg";
      group = "borg";
      authorizedKeys =
        [ (lib.readFile ../../common/users/vawvaw/home/pubkey_ssh.txt) ];
    };
    jobs."local" = {
      user = "borg";
      group = "syncthing";
      persistentTimer = true;

      archiveBaseName = "syncthing";
      paths = [ "/var/lib/syncthing/data" ];
      compression = "lz4";

      repo = "/backup/borgbackup";
      encryption.mode = "none";

      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = -1;
      };
    };
  };

  systemd.services."borgbackup-job-local" = {
    serviceConfig = {
      Restart = lib.mkForce "on-failure";
      RestartSec = lib.mkForce 15;
    };

    onFailure = [ "unit-status-notification@%n.service" ];
  };
}
