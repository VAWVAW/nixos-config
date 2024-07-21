{ pkgs, config, ... }: {
  sops.secrets = {
    "ntfy-unit-fail" = {
      sopsFile = ../../../secrets/system.yaml;
      mode = "0400";
    };
  };

  systemd.services."unit-status-notification@" = let
    script = pkgs.writeScript "unit-status-notification" ''
      UNIT=$1
      HOST=$2

      UNITSTATUS=$(systemctl status $UNIT)

      # import variables
      eval $(systemctl show -p Restart -p NRestarts $UNIT)

      if [ "$Restart" != "no" ] && [ "$NRestarts" -ne "5" ]; then
        echo "Unit tries to restart, no notification yet"
        exit
      fi

      ${pkgs.ntfy-sh}/bin/ntfy publish --token "$(${pkgs.coreutils}/bin/cat ${
        config.sops.secrets."ntfy-unit-fail".path
      })" --tags warning,computer --title "$UNIT failed on $HOST" https://ntfy.nlih.de/desktop "$(${pkgs.systemd}/bin/journalctl -b0 -u "$UNIT" -o cat -n 50)"
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
