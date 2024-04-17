{ lib, ... }: {
  imports = [
    ../common/optional/boot-partition.nix
    ../common/optional/btrfs-swapfile.nix
    ../common/optional/sslh.nix
    ../common/optional/systemd-initrd.nix

    ../common/global

    ./config
    ../common/users/vawvaw
  ];

  networking = {
    hostName = "nyx";
    hosts = {
      "192.168.2.10" = [ "hades" ];
      "192.168.2.11" = [ "athena" ];
    };

    resolvconf.enable = true;
    nameservers = [
      # quad9
      "9.9.9.10"
      "149.112.112.10"
      "2620:fe::10"
      "2620:fe::fe:10"
      # cloudflare
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];

    interfaces."enu1u1u1" = {
      ipv4 = {
        addresses = [{
          address = "192.168.2.20";
          prefixLength = 24;
        }];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "192.168.2.1";
          }
          {
            address = "192.168.2.0";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  boot = {
    kernelParams =
      [ "ip=192.168.2.20::192.168.2.1:255.255.255.0::enp0s31f6:off" ];
    blacklistedKernelModules = [ "onboard_usb_hub" ];
    initrd = {
      availableKernelModules = [
        "usbhid"
        "usb_storage"

        # network driver
        "lan78xx"
      ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 443;
          hostKeys = [ /persist/etc/ssh/ssh_initrd_host_ed25519_key ];
          authorizedKeys =
            [ (lib.readFile ../common/users/vawvaw/home/pubkey_ssh.txt) ];
        };
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = true;
        configurationLimit = 40;
      };
    };
  };

  system.stateVersion = "23.11";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
