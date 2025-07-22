{
  lib,
  fastmcp,
  python3,
  markdown-to-confluence,
  types-cachetools,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mcp-atlassian";
  version = "0.11.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-R6edqlPgM63KRZO2rVmVWGjMRSNzIvD8P00A9vpdW9Y=";
  };

  build-system = [
    python3.pkgs.pythonRelaxDepsHook
    python3.pkgs.hatchling
  ];

  pythonRelaxDeps = [
    "fastmcp"
  ];

  dependencies = with python3.pkgs; [
    atlassian-python-api
    beautifulsoup4
    cachetools
    click
    fastmcp
    httpx
    keyring
    markdown
    markdown-to-confluence
    markdownify
    mcp
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
