_: {
  # Adds my custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  freesweep = import ./freesweep;

  goimapnotify = import ./goimapnotify;

  waybar = import ./waybar;

  xkbcomp = import ./xkbcomp;
}
