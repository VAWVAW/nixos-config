{
  imports = [
    ./global.nix

    ./features/desktop/sway
    ./features/desktop/common/steam.nix
  ];

  services.spotifyd.settings.global.device_name = "vaw-laptop_spotifyd";

  battery = {
    enable = true;
    name = "BAT1";
  };

  home.shellAliases = {
    nswitch = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild switch --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
    nboot = "sudo umount /boot && sudo mount /boot -o rw && sudo nixos-rebuild boot --flake /etc/nixos# && sudo umount /boot && sudo mount /boot";
  };
}