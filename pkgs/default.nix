{ pkgs ? import <nixpkgs> { } }: {
  pythonPackagesExtensions = [
    (python-final: _python-prev: {
      spotifython = python-final.callPackage ./spotifython { };
    })
  ];
  spotifython-cli = pkgs.callPackage ./spotifython-cli { };
  statnot = pkgs.callPackage ./statnot { };
}
