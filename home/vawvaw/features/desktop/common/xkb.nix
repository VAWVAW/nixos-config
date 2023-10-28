{
  xdg.configFile = {
    "xkb/rules/evdev".text = ''
      ! option                =       symbols
        custom:qwerty_y_z     =       +custom(qwerty_y_z)
        custom:qwertz_y_z     =       +custom(qwertz_y_z)

      ! include %S/evdev
    '';

    "xkb/symbols/custom".text = ''
      partial alphanumeric_keys
      xkb_symbols "qwertz_y_z" {
        key <AD06>  {[      z,      Z ]};
        key <AB01>  {[      y,      Y ]};
      };

      partial alphanumeric_keys
      xkb_symbols "qwerty_y_z" {
        key <AD06>  {[      y,      Y ]};
        key <AB01>  {[      z,      Z ]};
      };
    '';
  };
}
