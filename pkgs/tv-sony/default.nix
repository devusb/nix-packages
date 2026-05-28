{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  inherit (python3Packages)
    buildPythonPackage
    setuptools-scm
    cryptography
    requests
    pygments
    ;
in
buildPythonPackage {
  pname = "tv-sony";
  version = "0.2.3-unstable-2023-01-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "philpennock";
    repo = "tv-sony";
    rev = "a989251137b8fd3e5b8ae0b4c1d5a201fa06590f";
    hash = "sha256-YJYPEcBCIpPmSUXwpVs4gZij3LEg921d2RGm2U8pT5U=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    cryptography
    requests
    pygments
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 tv $out/bin/tv
    runHook postInstall
  '';

  meta = with lib; {
    description = "Remote control app for Sony TVs (Python, CLI, for computers with shells, not phones";
    homepage = "https://github.com/philpennock/tv-sony";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "tv";
    platforms = platforms.all;
  };
}
