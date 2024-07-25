{ lib, buildPythonPackage, pythonOlder, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotifython";
  version = "0.2.8";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fe47ea908df4085df69cc4db85ac6535af283968c3165d528302db8acc9fdff";
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
