{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.services.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
    };
    environment.variables.PULSE_COOKIE = "${pkgs.writeText "pulse-cookie"
      (lib.concatStringsSep "" (map (_: "a") (lib.range 1 256)))}";
  };
}
