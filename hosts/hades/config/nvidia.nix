{ inputs, pkgs, ... }: {
  specialisation."nvidia".configuration = {
    imports = [ inputs.hardware.nixosModules.common-gpu-nvidia-nonprime ];

    environment.systemPackages = with pkgs; [ nvtopPackages.full ];

    boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };
}
