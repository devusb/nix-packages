{
  lib,
  python3,
  markdown-to-confluence,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcp-atlassian";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-ChYP6Ia4UMysBZz0+dtXq3pA9+eBJUKsvCxSbswUJV0=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    atlassian-python-api
    beautifulsoup4
    click
    httpx
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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mcp-atlassian";
  };
}
