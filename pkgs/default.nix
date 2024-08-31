{ pkgs }: {
  spotifython-cli = pkgs.callPackage ./spotifython-cli { };
  statnot = pkgs.callPackage ./statnot { };
}
