{
  lib,
  coreutils,
  fastmcp,
  python3,
  markdown-to-confluence,
  fetchFromGitHub,
}:
let
  atlassian-python-api' = python3.pkgs.atlassian-python-api.overridePythonAttrs (old: rec {
    version = "4.0.3";
    src = old.src.override {
      tag = version;
      hash = "sha256-po3oW6ncHx6uSFIGJUkbrevvgmvTiJ3eVLeNbYuc1us=";
    };
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      python3.pkgs.typing-extensions
    ];
  });

  mcp' = python3.pkgs.mcp.overridePythonAttrs (old: rec {
    version = "1.8.0";
    src = old.src.override {
      tag = "v${version}";
      hash = "sha256-OhMAQYOOJ5oUkRj1Ijj4/b6aiPU9FfCuz5GmywGfMRY=";
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
  pname = "mcp-atlassian";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-UTsXbNd1RX8jHgG2Mb6a9cGhZjWj0xgS1fR6IOdupe4=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    atlassian-python-api'
    beautifulsoup4
    click
    fastmcp
    httpx
    keyring
    markdown
    markdown-to-confluence
    markdownify
    mcp'
    pydantic
    python-dotenv
    python-dateutil
    starlette
    thefuzz
    trio
    types-python-dateutil
    uvicorn
  ];

  pythonImportsCheck = [
    "mcp_atlassian"
  ];

  meta = {
    description = "MCP server that integrates Confluence and Jira";
    homepage = "https://github.com/sooperset/mcp-atlassian";
    changelog = "https://github.com/sooperset/mcp-atlassian/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "mcp-atlassian";
  };
}
