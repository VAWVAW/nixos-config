{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotifython";
  version = "0.2.5";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a47a0a165440caa930a78deae711fdc047513374d9fb487af080e6215e1559eb";
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
