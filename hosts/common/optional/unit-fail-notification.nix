{ pkgs, config, ... }: {
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

  systemd.services."unit-status-notification@" = let
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

}
