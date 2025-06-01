{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "fastmcp";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    rev = "v${version}";
    hash = "sha256-QyczoC/AylhKrHO4c4s2ALPHQuL+CtfOKHMIehlkPJQ=";
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
