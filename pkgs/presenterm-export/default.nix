{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "presenterm-export";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mfontanini";
    repo = "presenterm-export";
    rev = "v${version}";
    hash = "sha256-HfBCvvB5ZM+bSZLFUCu20IRYpiaODYLxTSjRmTImLio=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ansi2html
    dataclass-wizard
    libtmux
    pillow
    weasyprint
  ];

  pythonImportsCheck = [ "presenterm_export" ];

  pythonRelaxDeps = true;

  meta = with lib; {
    description = "PDF exporter for presenterm presentations";
    homepage = "https://github.com/mfontanini/presenterm-export";
    license = licenses.bsd2;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "presenterm-export";
  };
}
