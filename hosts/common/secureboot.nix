{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.boot.lanzaboote.enable {
    environment = {
      systemPackages = with pkgs; [ sbctl ];
      persistence."/persist".directories = [ config.boot.lanzaboote.pkiBundle ];
    };

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
    };
  };
}
