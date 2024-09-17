{ lib, ... }: {
  imports = [ ./arch-install ];

  networking.hostName = lib.mkForce "nixos-iso";

  desktop.enable = true;

  programs.command-not-found.enable = true;

  users.mutableUsers = lib.mkForce true;
  users.users."vaw" = {
    initialHashedPassword = "";
    hashedPasswordFile = lib.mkForce null;
  };

  services.getty.autologinUser = lib.mkForce "vaw";

  boot.initrd.systemd.enable = false;
}
