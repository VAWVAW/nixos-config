{ lib, python3, pkgs, fetchFromGitHub, installShellFiles
, spotifython ? python3.pkgs.spotifython, shtab ? python3.pkgs.shtab
, sphinx-argparse ? python3.pkgs.sphinx-argparse, libnotify ? pkgs.libnotify, }:

python3.pkgs.buildPythonApplication rec {
  pname = "spotifython-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "vawvaw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yp3cwzz84hcy6i0s1xip9qna5hfdpwa8gimn3dzqavvy89hcvd4";
  };

  nativeBuildInputs = [ installShellFiles shtab sphinx-argparse ];
  propagatedBuildInputs = [ spotifython libnotify ];

  postBuild = ''
    python -m shtab 'spotifython_cli.generate_parser' -s bash > completion.bash
    python -m shtab 'spotifython_cli.generate_parser' -s zsh > completion.zsh
    make --directory docs man
  '';
  postInstall = ''
    installShellCompletion --cmd ${pname} completion.{bash,zsh}
    installManPage docs/_build/man/spotifython-cli.1.gz
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
