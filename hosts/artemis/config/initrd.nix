{ config, lib, ... }: {
  boot.initrd = {

    systemd = {
      inherit (config.systemd) network;
      enable = true;
    };
    network = {
      ssh = {
        enable = true;
        port = 443;
        hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
        authorizedKeys =
          [ (lib.readFile ../../common/users/vaw/home/pubkey_ssh.txt) ];
      };
    };
  };
}
