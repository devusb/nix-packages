{
  lib,
  coreutils,
  fastmcp,
  python3,
  markdown-to-confluence,
  types-cachetools,
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
  pname = "mcp-atlassian";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-chfANVb+HXNFsMDngW9s/YUV4KJaxC1rJ7GAVOWmJk4=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    atlassian-python-api'
    beautifulsoup4
    cachetools
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
    types-cachetools
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
