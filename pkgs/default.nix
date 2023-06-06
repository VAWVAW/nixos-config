{ pkgs ? import <nixpkgs> { } }: {
  pythonPackagesExtensions = [
    (python-final: python-prev: {
      spotifython = python-final.callPackage ./spotifython { };
    })
  ];
  spotifython-cli = pkgs.callPackage ./spotifython-cli { };
  divera-status = pkgs.callPackage ./divera-status { };
}
