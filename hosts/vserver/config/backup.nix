{ pkgs, config, lib, ... }: {
  environment.systemPackages = with pkgs; [ discord-sh sshfs ];

  sops.secrets = {
    backup-key = {
      sopsFile = ../../common/secrets.yaml;
      mode = "0400";
    };
    discord-webhook = {
      sopsFile = ../../common/secrets.yaml;
      mode = "0400";
    };
  };

  # change systemd units
  services.borgbackup.jobs = {
    server = {
      paths = [ "/backed_up_frozen" ];
      exclude = [ "re:/\\.git/" ];
      archiveBaseName = "${config.networking.hostName}";
      extraCreateArgs = "--exclude-caches --keep-exclude-tags";
      extraPruneArgs = "--save-space";
      preHook = ''
        trap EXIT
        ${pkgs.sshfs}/bin/sshfs hosting124304@vaw-valentin.de:/backup $RUNTIME_DIRECTORY -o IdentityFile=/persist/etc/ssh/ssh_host_ed25519_key -v
        trap on_exit EXIT

        export BORG_REPO=$RUNTIME_DIRECTORY/backup
        realBorg="$(${pkgs.which}/bin/which borg)"

        # don't fail on warnings with exitcode 1
        borg(){
          returnCode=0

          out=$("$realBorg" "$@") || returnCode=$?

          echo $out

          if [[ $returnCode -ne 1 ]]; then
            return $returnCode
          fi

          warnings=$(echo $out | grep "Warning" | grep -v "prefix")
          if [ -n "$warnings" ]; then
            return 1
          fi
          return 0
        }
      '';
      postHook = ''
        if [ "$exitStatus" -eq "0" ]; then
          borg compact $extraArgs
        fi
        /run/wrappers/bin/umount $RUNTIME_DIRECTORY
      '';
      repo = "will be:changed";
      compression = "lzma";
      encryption.mode = "repokey";
      encryption.passCommand = "cat ${config.sops.secrets.backup-key.path}";
      doInit = false;
      persistentTimer = true;
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = -1;
      };
    };
  };
  systemd.services = {
    borgbackup-job-server = {
      # create readonly snapshot before backup
      wants = [ "snapshot-backed-up.service" ];
      after = [ "snapshot-backed-up.service" ];

      serviceConfig.Restart = lib.mkForce "on-failure";
      serviceConfig.RestartSec = lib.mkForce 15;
      serviceConfig = { RuntimeDirectory = "backup"; };

      onFailure = [ "unit-status-notification@%n.service" ];
      environment = {
        BORG_RSH =
          "${pkgs.openssh}/bin/ssh -i /persist/etc/ssh/ssh_host_ed25519_key";
      };
    };
    snapshot-backed-up = {
      description = "creates readonly snapshot of /backed_up in /backed_up_frozen";
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /backed_up /backed_up_frozen";
      };
    };
    "unit-status-notification@" = let
      script = pkgs.writeScript "unit-status-notification" ''
        MAILTO=valentin@wiedekind1.de
        MAILFROM=unit-status
        UNIT=$1
        HOST=$2

        UNITSTATUS=$(systemctl status $UNIT)


        # import variables
        eval $(systemctl show -p Restart -p NRestarts $UNIT)

        if [ "$Restart" != "no" ] && [ "$NRestarts" -ne "5" ]; then
          echo "Unit tries to restart, no notification yet"
          exit
        fi

        /run/wrappers/bin/sendmail $MAILTO <<EOF
        To:$MAILTO
        Subject:Status mail for unit: $UNIT

        Status report for unit: $UNIT ($HOST)

        $UNITSTATUS
        EOF

        echo -e "Status mail sent to $MAILTO for unit $UNIT"

        ${pkgs.discord-sh}/bin/discord.sh \
          --title "$UNIT ($HOST)" \
          --color "0xFF0000" \
          --description "$(echo $UNITSTATUS | ${pkgs.jq}/bin/jq -Rs . | cut -c 2- | ${pkgs.util-linux}/bin/rev | cut -c 2- | ${pkgs.util-linux}/bin/rev)" \
          --webhook-url "$(cat ${config.sops.secrets.discord-webhook.path})"
      '';
    in {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.bash}/bin/bash ${script} %I %H";
      };
      unitConfig = {
        Description = "Unit status notification service";
        After = "network.target";
      };
    };
  };
}
