{ pkgs, inputs, lib, config, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment = {
    systemPackages = with pkgs; [ sbctl ];
    persistence."/persist".directories = [ config.boot.lanzaboote.pkiBundle ];
  };

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
    };
  };
}
