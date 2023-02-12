{ pkgs, ... }:
{
  home.packages = with pkgs;[
    wireplumber
    noisetorch
    (writeScriptBin "set-volume" "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ $1")
  ];
}
