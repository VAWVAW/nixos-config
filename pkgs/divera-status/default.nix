{
  lib,
  fetchFromGitHub,
  rustPackages,
  pkg-config,
  openssl,
}:

rustPackages.rustPlatform.buildRustPackage rec {
  pname = "divera-status";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "VAWVAW";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WWaaVtAMmfC/QYZWqQQliEBDsILP0uWTMCNxxR1iCbo=";
  };

  cargoSha256 = "sha256-CPp1i93WxKZJmJ4RwpNQFNDvstwiSvjgd0R8Zn5agDA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # no tests in repo
  doCheck = false;

  meta = with lib; {
    description = "An integration of divera247 with i3blocks";
    homepage = "https://github.com/vawavw/divera-status";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ vawvaw ];
  };
}
