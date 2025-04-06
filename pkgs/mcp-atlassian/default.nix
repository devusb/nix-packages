{
  lib,
  python3,
  markdown-to-confluence,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcp-atlassian";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-Z59LwKsZV6ja0tS172tN+Wj8dNp/GIuF9N7K0iLPAm0=";
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
    starlette
    trio
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
