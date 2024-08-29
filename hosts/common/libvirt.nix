{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.virtualisation.libvirtd.enable {
    virtualisation.libvirtd = {
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    environment.systemPackages = with pkgs; [ virt-manager ];
    environment.persistence."/persist" = {
      directories = [ "/var/lib/libvirt" ];
    };
  };
}
