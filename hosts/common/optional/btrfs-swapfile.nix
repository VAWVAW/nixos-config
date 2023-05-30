{ config, ... }:
{
  fileSystems."/swap" =
    let
      hostname = config.networking.hostName;
    in
    {
      device = "/dev/disk/by-label/system_partition";
      fsType = "btrfs";
      options = [ "subvol=${hostname}/swap" "noatime" "compress=zstd" ];
    };

  swapDevices = [{
    device = "/swap/swapfile";
  }];
}
