{ lib, ... }:

with lib;

{
  options.battery = {
    enable = mkEnableOption "battery";
    name = mkOption {
      type = types.str;
      description = ''
        Internal name of the battery.
      '';
    };
  };
}
