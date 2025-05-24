{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "md2conf";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hunyadi";
    repo = "md2conf";
    rev = version;
    hash = "sha256-iUkLbsu/KTzPwBX9+bSwdXsxV6NDe7iTHF+fKHZH7R0=";
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
    types-lxml
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
