{ lib, config, inputs, ... }:
let
  hostname = config.networking.hostName;
  wipeScript = ''
    mkdir -p /btrfs
    mount -o subvol=/ /dev/disk/by-label/${hostname} /btrfs

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
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  # Use postDeviceCommands if on old phase 1
  boot.initrd.postDeviceCommands = lib.mkBefore wipeScript;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/root" "compress=zstd" ];
    };

    "/nix" = lib.mkDefault {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/persist" "compress=zstd" ];
      neededForBoot = true;
    };

    "/local_persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/local_persist" "compress=zstd" ];
      neededForBoot = true;
    };
  };

  environment.persistence."/persist".hideMounts = true;
  environment.persistence."/local_persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/systemd/timers"
    ];
  };
}
