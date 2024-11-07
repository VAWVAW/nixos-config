{ config, lib, ... }: {

  boot.initrd.network.ssh = {
    enable = true;
    port = 443;
    hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
    authorizedKeys = [ (lib.readFile ./users/vaw/home/pubkey_ssh.txt) ];
  };

  boot.initrd.systemd = {
    enable = lib.mkDefault true;
    network = config.systemd.network // { enable = lib.mkDefault false; };

    # default dependency "network.target" is reached after partition is unlocked while connectivity exists before that
    services."sshd" = {
      after = lib.mkForce [ "initrd-nixos-copy-secrets.service" ];
      before = [ "systemd-ask-password-console.service" ];
    };

    services."print-info" = {
      enable = lib.mkDefault false;
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
        echo 'This device belongs to Valentin <valentin@vaw-valentin.de>.' > /dev/tty1
        echo "" > /dev/tty1
        echo '###########################################################' > /dev/tty1
        echo "" > /dev/tty1
      '';
    };

  };
}
