{ pkgs, lib, ... }: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
  };
  environment.variables.PULSE_COOKIE = "${pkgs.writeText "pulse-cookie"
    (lib.concatStringsSep "" (map (_: "a") (lib.range 1 256)))}";
}
