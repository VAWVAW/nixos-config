{ lib, ... }: {
  specialisation."ovmf".configuration = {
    services.xserver.videoDrivers = lib.mkForce [ ];
    boot = {
      kernelParams = [
        # enable pci groups
        "amd_iommu=on"
        "iommu=pt"
        # specify vfio-pci to use my nvidia gpu
        "vfio-pci.ids=10de:1c03,10de:10f1"
      ];
      extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';
      blacklistedKernelModules =
        [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
    };
    hardware.nvidia = {
      modesetting.enable = lib.mkForce false;
      powerManagement.enable = lib.mkForce false;
    };
  };
}
