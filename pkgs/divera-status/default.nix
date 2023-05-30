{ lib
, fetchFromGitHub
, rustPackages
, pkg-config
, openssl
, dbus
,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "divera-status";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "VAWVAW";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sFfVIRMzy1MiPZ/r2rX2m5dZ8FG7o12REiD5bJl+uFQ=";
  };

  cargoSha256 = "sha256-W8Wxq0brFxrRlpOX1J79L5YAJjn2wk3IlJsrqHtFvPs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus ];

  buildFeatures = [ "i3blocks" "dbus-interface" ];

  cargoBuildFlags = [ "--workspace" ];

  # no tests in repo
  doCheck = false;

  meta = with lib; {
    description = "An integration of divera247 with i3blocks";
    homepage = "https://github.com/vawavw/divera-status";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ vawvaw ];
  };
}
