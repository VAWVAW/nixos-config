{ config, pkgs, lib, ... }: {
  options.services.borgbackup.jobs = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ config, ... }: {
      options = {
        backupSnapshot = lib.mkEnableOption "backup a snapshot of /backed_up";
        sshKey = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "ssh key to use for repo access";
          default = null;
        };
      };
      config = lib.mkMerge [
        {
          user = lib.mkDefault "borg";
          group = lib.mkDefault "borg";

          prune.keep = lib.mkDefault {
            within = "1d";
            daily = 7;
            weekly = 4;
            monthly = -1;
          };

          environment."BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK" = "yes";
        }
        (lib.mkIf config.backupSnapshot {
          extraCreateArgs = [ "--paths-from-command" ];
          paths = let path = "$STATE_DIRECTORY/snapshot";
          in [
            (builtins.toString (pkgs.writeShellScript "borgbackup_paths"
              ''${pkgs.findutils}/bin/find "${path}" 2>/dev/null | grep -v "^${path}$" | sed "s_snapshot_snapshot/._"''))
          ];
          exclude = [
            "**/var/lib/syncthing/data/Documents/coding/**/.git"
            "**/var/lib/syncthing/data/Documents/studium/*/nextcloud/*/*.mp4"
          ];
        })
        (lib.mkIf (config.sshKey != null) {
          environment."BORG_RSH" =
            "${pkgs.openssh}/bin/ssh -oBatchMode=yes -i %d/ssh_key";
        })
      ];
    }));
  };

  options.services.borgbackup.repos = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ config, ... }: {
      config = {
        path = lib.mkDefault "/backup/borgbackup";
        user = lib.mkDefault "borg";
        group = lib.mkDefault "borg";
        authorizedKeys = [ (lib.readFile ./users/vaw/home/pubkey_ssh.txt) ];
      };
    }));
  };

  config = lib.mkMerge [
    (lib.mkIf (config.services.borgbackup.repos != { }
      || config.services.borgbackup.jobs != { }) {
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
      })

    (lib.mkIf (config.services.borgbackup.jobs != { }) {
      systemd.services."unit-status-notification@".enable = true;
    })

    {
      systemd.services = builtins.listToAttrs (map (name:
        let cfg = config.services.borgbackup.jobs."${name}";
        in {
          name = "borgbackup-job-${name}";
          value = {
            serviceConfig = {
              Type = "oneshot";
              Restart = lib.mkDefault "on-failure";
              RestartSec = lib.mkDefault 60;
            };
            onFailure = [ "unit-status-notification@%n.service" ];
          } // (lib.optionalAttrs cfg.backupSnapshot {
            serviceConfig = {
              StateDirectory = "borgbackup-${name}";
              ExecStartPre =
                "+${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /backed_up \${STATE_DIRECTORY}/snapshot";
              ExecStopPost =
                "+${pkgs.btrfs-progs}/bin/btrfs subvolume delete \${STATE_DIRECTORY}/snapshot";
            };
          }) // (lib.optionalAttrs (cfg.sshKey != null) {
            serviceConfig.LoadCredential = [ "ssh_key:${cfg.sshKey}" ];
          });
        }) (builtins.attrNames config.services.borgbackup.jobs));

      systemd.timers = builtins.listToAttrs (map (name: {
        name = "borgbackup-job-${name}";
        value.timerConfig.RandomizedDelaySec = "1h";
      }) (builtins.attrNames config.services.borgbackup.jobs));
    }
  ];
}
