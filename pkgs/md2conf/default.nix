{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "md2conf";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hunyadi";
    repo = "md2conf";
    rev = version;
    hash = "sha256-Pmm1OpeeAHk5UqqTOsRgbJKSg+5Aqh5PWFPWXi0+cAU=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    flake8
    lxml
    markdown
    mypy
    pymdown-extensions
    pyyaml
    requests
    (types-lxml.overrideAttrs (old: rec {
      version = "2024.12.13";
      src = old.src.override {
        tag = version;
        hash = "sha256-iqIOwQIg6EB/m8FIoUzkvh1W0w4bKmS9zi4Z+5qlC+0=";
      };
    }))
    types-markdown
    types-pyyaml
    types-requests
  ];

  pythonImportsCheck = [
    "md2conf"
  ];

  meta = {
    description = "Publish Markdown files to Confluence wiki";
    homepage = "https://github.com/hunyadi/md2conf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "md2conf";
  };
}
