# My NixOS configurations
modeled after [misterio's config](https://git.sr.ht/~misterio/nix-config).

# Installation

## Partition layout
boot partition
- Label: "BOOT"
- optional with "boot-partition.nix"
- type: vfat

luks2 partition
- Label: "system\_crypt"
- contains: btrfs partition
  - Label: "system\_partition"
  - subvolumes:
    - "${hostname}"
      - "root": blank subvolume; mountpoint: "/"
      - "root-blank": readonly snapshot of "root"; not mounted
      - "nix": mountpoint: "/nix"
      - "backed\_up": persistent and backed up data; mountpoint: "/backed\_up"
      - "persist": persistent data; mountpoint: "/persist"
      - "swap": optional with "btrfs-swapfile.nix"; mountpoint: "/swap"; contains: "swapfile" swapfile
