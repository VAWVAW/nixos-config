{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotifython";
  version = "0.2.6";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d31b5306b9c1de69469b07e1f56f99d48f06ad5519702125f85b37b3a8674c7";
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
