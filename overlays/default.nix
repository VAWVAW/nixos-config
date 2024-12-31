_: {
  # Adds my custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  pythonPackages = _final: _prev: {
    pythonPackagesExtensions = [
      (python-final: _python-prev: {
        spotifython = python-final.callPackage ../pkgs/spotifython { };
      })
    ];
  };

  freesweep = import ./freesweep;

  waybar = import ./waybar;

  xkbcomp = import ./xkbcomp;
}
