{ pkgs, ... }: {
  systemd.services."rtc-sleep" = {
    description = "Makes the device sleep from 1 am to 11 am.";
    script = "${pkgs.util-linux}/bin/rtcwake --mode mem --seconds ${
        builtins.toString (10 * 3600)
      }";

    startAt = [ "01:00" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
