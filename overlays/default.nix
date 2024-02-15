_: {
  # Adds my custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  freesweep = import ./freesweep;

  waybar = import ./waybar;
}
