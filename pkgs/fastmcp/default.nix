{
  lib,
  coreutils,
  python3,
  fetchFromGitHub,
}:
let
  mcp' = python3.pkgs.mcp.overridePythonAttrs (old: rec {
    version = "1.8.1";
    src = old.src.override {
      tag = "v${version}";
      hash = "sha256-r3B/2Nzb3Cai0/k7dMmcduWQWsbkhYW6UVyaE4BCz/Y=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail ', "uv-dynamic-versioning"' "" \
        --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
      substituteInPlace tests/client/test_stdio.py \
        --replace '/usr/bin/tee' '${lib.getExe' coreutils "tee"}'
    '';

    dependencies = old.dependencies ++ [
      python3.pkgs.python-multipart
    ];

    nativeCheckInputs = old.nativeCheckInputs ++ [
      python3.pkgs.requests
    ];
  });
in
python3.pkgs.buildPythonApplication rec {
  pname = "fastmcp";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    rev = "v${version}";
    hash = "sha256-JM8Vi3WRp+d8qMTGFDPgNg2hKevjVJuYkyYAyOx/2wQ=";
  };

  build-system = [
    python3.pkgs.hatchling
    python3.pkgs.uv-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    exceptiongroup
    httpx
    mcp'
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
