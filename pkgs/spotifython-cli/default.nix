{ lib, python3, fetchFromGitHub, installShellFiles
, spotifython ? (python3.pkgs.callPackage ../spotifython { }), }:

python3.pkgs.buildPythonApplication rec {
  pname = "spotifython-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "vawvaw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kfcswmgjan5ailwjg0kz6hiw939pqrj4mzsk9d7xw73p2j0yigl";
  };

  nativeBuildInputs = [ installShellFiles ];
  propagatedBuildInputs = [ spotifython python3.pkgs.click ];

  postInstall = ''
    _SPOTIFYTHON_CLI_COMPLETE=bash_source $out/bin/spotifython-cli > completion.bash
    _SPOTIFYTHON_CLI_COMPLETE=zsh_source $out/bin/spotifython-cli > completion.zsh
    _SPOTIFYTHON_CLI_COMPLETE=fish_source $out/bin/spotifython-cli > completion.fish
    installShellCompletion --cmd ${pname} completion.{bash,zsh,fish}
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
