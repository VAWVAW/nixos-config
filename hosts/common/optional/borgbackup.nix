{ pkgs, lib, config, ... }: {
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
        [ (lib.readFile ../../common/users/vaw/home/pubkey_ssh.txt) ];
    };
    jobs = let path = "$STATE_DIRECTORY/snapshot";
    in {
      "local" = {
        user = "borg";
        group = "borg";
        persistentTimer = true;

        preHook = ''
          export extraCreateArgs="$extraCreateArgs --paths-from-command"
        '';
        paths = [
          (builtins.toString (pkgs.writeShellScript "borgbackup_paths"
            ''${pkgs.findutils}/bin/find "${path}" 2>/dev/null''))
        ];
        exclude = [
          "**/var/lib/syncthing/data/Documents/coding/**/.git"
          "**/var/lib/syncthing/data/Documents/studium/*/nextcloud/*/*.mp4"
        ];

        archiveBaseName = "data";
        compression = "lz4";

        prune.keep = {
          within = "1d";
          daily = 7;
          weekly = 4;
          monthly = -1;
        };

        # more custom option
        repo = "/backup/borgbackup";
        encryption.mode = "none";
      };
    };
  };

  systemd.services = builtins.listToAttrs (map (name: {
    name = "borgbackup-job-${name}";
    value = {
      serviceConfig = {
        Type = "oneshot";
        Restart = lib.mkForce "on-failure";
        RestartSec = lib.mkForce 60;

        StateDirectory = "borgbackup-${name}";
        ExecStartPre =
          "+${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /backed_up \${STATE_DIRECTORY}/snapshot";
        ExecStopPost =
          "+${pkgs.btrfs-progs}/bin/btrfs subvolume delete \${STATE_DIRECTORY}/snapshot";
      };
      onFailure = [ "unit-status-notification@%n.service" ];
    };
  }) (builtins.attrNames config.services.borgbackup.jobs));
}
