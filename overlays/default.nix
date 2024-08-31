_: {
  # Adds my custom packages
  additions = final: _prev: import ../pkgs { pkgs = final; };

  pythonPackages = final: prev: {
    pythonPackagesExtensions = [
      (python-final: _python-prev: {
        spotifython = python-final.callPackage ../pkgs/spotifython { };
      })
    ];
  };

  freesweep = import ./freesweep;

  goimapnotify = import ./goimapnotify;

  waybar = import ./waybar;

  xkbcomp = import ./xkbcomp;
}
