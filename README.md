# My NixOS configurations
modeled after [misterio's config](https://git.sr.ht/~misterio/nix-config).

# Installation

## Partition layout
boot partition
- Label: "BOOT"
- optional with "boot-partition.nix"
- type: vfat

luks2 partition
- Label: "system_crypt"
- conains: btrfs partition
  - Label: "system_partition"
  - subvolumes:
    - "${hostname}"
      - "root": blank subvolume; mountpoint: "/"
      - "root-blank": readonly snapshot of "root"; not mounted
      - "nix": mountpoint: "/nix"
      - "persist": persistent and backed up data; mountpoint: "/persist"
      - "local_persist": persistent data; mountpoint: "/local_persist"
      - "swap": optional with "btrfs-swapfile.nix"; mountpoint: "/swap"; contains: "swapfile" swapfile
