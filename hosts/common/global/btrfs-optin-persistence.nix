{ lib, config, inputs, ... }:
let
  hostname = config.networking.hostName;
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ /dev/disk/by-label/system_partition /btrfs

    if [ -e "/btrfs/${hostname}/root/dontwipe" ]; then
      echo "Not wiping root"
    else
      echo "Cleaning subvolume"
      btrfs subvolume list -o /btrfs/${hostname}/root | cut -f9 -d ' ' |
      while read subvolume; do
        btrfs subvolume delete "/btrfs/$subvolume"
      done && btrfs subvolume delete /btrfs/${hostname}/root

      echo "Restoring blank subvolume"
      btrfs subvolume snapshot /btrfs/${hostname}/root-blank /btrfs/${hostname}/root
    fi

    umount /btrfs
    rmdir /btrfs
  '';
in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];

    # Use postDeviceCommands if on old phase 1
    postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (lib.mkBefore wipeScript);

    # Use systemd service on new phase 1
    systemd.services."rollback-root" = {
      description = "Rollback BTRFS root subvolume to empty state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@system_partition.service" ];
      before = [ "sysroot.mount" ];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = wipeScript;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/root" "compress=zstd" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/persist" "compress=zstd" ];
      neededForBoot = true;
    };
    "/swap" = {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/swap" "noatime" "compress=zstd" ];
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [ "/var/log" "/var/lib/systemd/timers" "/var/lib/nixos" ];
    files = [ "/etc/machine-id" ];
  };

  swapDevices = [{ device = "/swap/swapfile"; }];
}
