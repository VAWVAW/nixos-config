{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  environment.persistence."/local_persist" = {
    directories = [
      "/var/lib/libvirt"
    ];
  };
}
