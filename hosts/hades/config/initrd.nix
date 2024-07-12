{ config, lib, ... }: {
  boot.initrd = {

    # network driver
    availableKernelModules = [ "r8169" ];

    systemd = {
      inherit (config.systemd) network;
      enable = true;
    };

    network.ssh = {
      enable = true;

      hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
      authorizedKeys =
        [ (lib.readFile ../../common/users/vaw/home/pubkey_ssh.txt) ];
    };
  };
}
