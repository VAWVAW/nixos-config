{
  boot.initrd.systemd = {
    enable = true;
    services."print-info" = {
      wantedBy = [ "initrd.target" ];
      requires = [ "systemd-vconsole-setup.service" ];
      after = [ "systemd-vconsole-setup.service" ];
      before = [ "systemd-ask-password-console.service" ];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        echo "" > /dev/tty1
        echo '###########################################################' > /dev/tty1
        echo "" > /dev/tty1
        echo 'This laptop belongs to Valentin <valentin@vaw-valentin.de>.' > /dev/tty1
        echo "" > /dev/tty1
        echo '###########################################################' > /dev/tty1
        echo "" > /dev/tty1
      '';
    };
  };
}
