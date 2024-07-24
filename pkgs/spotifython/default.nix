{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotifython";
  version = "0.2.7";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfbd2551f9bef862842a70a1c4fbeb4e70be4412cb42740d99a4e0b00c8fc32a";
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
