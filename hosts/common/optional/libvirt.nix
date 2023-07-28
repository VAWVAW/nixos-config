{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
  environment.systemPackages = with pkgs; [ virt-manager ];
  environment.persistence."/local_persist" = {
    directories = [ "/var/lib/libvirt" ];
  };
}
