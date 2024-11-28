{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotifython";
  version = "0.2.11";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "862ecfa06a9b854a8bd5881e5f6ea18923b0feadfd4aa2778aa87ba63860449d";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  pythonImportsCheck =
    [ "spotifython" "spotifython.playlist" "spotifython.client" ];

  meta = with lib; {
    homepage = "https://github.com/vawvaw/spotifython";
    description =
      "caching python interface to readonly parts of the spotify api";
    license = licenses.gpl3;
    #maintainers = with maintainers; [ vawvaw ];
  };
}
