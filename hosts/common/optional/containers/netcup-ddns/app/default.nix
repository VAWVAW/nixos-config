{ pkgs, lib ? pkgs.lib, php ? pkgs.php }:

pkgs.stdenv.mkDerivation rec {
  name = "netcup-ddns";
  version = "4.0";

  src = pkgs.fetchFromGitHub {
    owner = "stecklars";
    repo = "dynamic-dns-netcup-api";
    rev = "v${version}";
    sha256 = "0vl8azi13l8r9l67yd7vyipj7hldsfphvz0cl909zqy263hh2sbn";
  };

  propagatedBuildInputs = [
    (php.withExtensions ({ all, enabled }:
      enabled ++ (with all; [ curl ])))
  ];

  patches = [
    ./require_config.diff
  ];

  postPatch = ''
    substituteInPlace update.php \
      --replace "__DIR__" "'$out/lib/netcup-ddns'"
  '';

  installPhase = ''
    install -Dm755 update.php $out/bin/netcup-ddns
    install -Dm644 functions.php $out/lib/netcup-ddns/functions.php
  '';

  meta = with lib; {
    homepage = "https://github.com/stecklars/dynamic-dns-netcup-api";
    description = "A simple dynamic DNS client written in PHP for use with the netcup DNS API.";
    license = licenses.mit;
  };
}
