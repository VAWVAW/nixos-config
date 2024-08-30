{ lib, python3Packages, fetchFromGitHub, wrapGAppsNoGuiHook }:

python3Packages.buildPythonApplication rec {
  pname = "statnot";
  version = "git";
  format = "other";

  src = fetchFromGitHub {
    owner = "halhen";
    repo = pname;
    rev = "d70982eb5d86e7849295b634721a74a433fcb532";
    sha256 = "0c6wd66920y270i65sayig7391i4vbs0v4hvhy5d986vd2arld90";
  };

  buildInputs = [ wrapGAppsNoGuiHook ];

  propagatedBuildInputs =
    [ python3Packages.dbus-python python3Packages.pygobject3 ];

  dontBuild = true;

  patches = [
    ./Replace-deprecated-imp-with-importlib.patch
    ./Add-app_name-as-extra-information.patch
  ];

  installPhase = ''
    install -Dm755 ./statnot $out/bin/statnot
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/vawvaw/spotifython-cli";
    description =
      "command line interface for spotifython intended for use with spotifyd";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ vawvaw ];
  };
}
