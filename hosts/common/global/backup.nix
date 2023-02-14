{ pkgs, config, lib, ... }:
{
  imports = [
    ./system-mail.nix
  ];
  environment.systemPackages = with pkgs; [
    discord-sh
    sshfs
  ];

  sops.secrets = {
    backup-key = {
      sopsFile = ../secrets.yaml;
      mode = "0400";
    };
    discord-webhook = {
      sopsFile = ../secrets.yaml;
      mode = "0400";
    };
  };

  # change systemd units
  services.borgbackup.jobs =
    let
      default-job = {
        paths = [
          "/persist"
        ];
        exclude = [
          "re:/\\.git/"
        ];
        extraCreateArgs = "--exclude-caches --keep-exclude-tags";
        preHook = ''
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
        '';
        repo = "borg@home.vaw-valentin.de:/backup/backup";
        compression = "auto,zstd,10";
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
    in
    {
      pi = default-job;
      server = default-job // {
        extraPruneArgs = "--save-space";
        repo = "/root/mnt/backup";
        startAt = [ "weekly" ];
        compression = "lzma";
        prune.keep = {
          weekly = 4;
          monthly = 12;
        };
        preHook = default-job.preHook + "mkdir /root/mnt && ${pkgs.sshfs}/bin/sshfs hosting124304@vaw-valentin.de:/backup /root/mnt";
        postHook = default-job.postHook + "/run/wrappers/bin/umount /root/mnt && rmdir /root/mnt";
        readWritePaths = [ "/root/mnt" ];
      };
    };
  systemd.services =
    let
      borg_default = {
        serviceConfig.Restart = lib.mkForce "on-failure";
        serviceConfig.RestartSec = lib.mkForce 15;
        onFailure = [ "unit-status-notification@%n.service" ];
        environment = {
          BORG_RSH = "${pkgs.openssh}/bin/ssh -i /local_persist/etc/ssh/ssh_host_ed25519_key";
        };
      };
    in
    {
      borgbackup-job-pi = borg_default;
      borgbackup-job-server = borg_default;
      "unit-status-notification@" =
        let
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
              --description "$(echo $UNITSTATUS | ${pkgs.jq}/bin/jq -Rs . | cut -c 2- | rev | cut -c 2- | rev)" \
              --webhook-url "$(cat ${config.sops.secrets.discord-webhook.path})"
          '';
        in
        {
          serviceConfig = {
            Type = "simple";
            ExecStart = ''${pkgs.bash}/bin/bash ${script} %I %H'';
          };
          unitConfig = {
            Description = "Unit status notification service";
            After = "network.target";
          };
        };
    };
}
