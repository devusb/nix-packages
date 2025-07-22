{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "fastmcp";
  version = "2.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    rev = "v${version}";
    hash = "sha256-Wxugk2ocuur710WZLG7xph2R/n02Y9BvH7Lf4BuEMYs=";
  };

  build-system = [
    python3.pkgs.hatchling
    python3.pkgs.uv-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    exceptiongroup
    httpx
    mcp
    openapi-pydantic
    python-dotenv
    rich
    typer
    websockets
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "fastmcp"
  ];

  meta = {
    description = "The fast, Pythonic way to build MCP servers and clients";
    homepage = "https://github.com/jlowin/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "fastmcp";
  };
}
