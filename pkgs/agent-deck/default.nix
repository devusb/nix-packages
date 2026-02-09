{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "agent-deck";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "asheshgoplani";
    repo = "agent-deck";
    rev = "v${version}";
    hash = "sha256-JSKixBRWZGYIJsndnKpDlvSmIe54iA/3MAyMbJjfwNQ=";
  };

  vendorHash = "sha256-A5ZFyf7nljg8x0mnGSqW/lNW52wwLGv8UBD3c6YycJM=";

  nativeCheckInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  meta = {
    description = "Terminal session manager for AI coding agents. Built with Go + Bubble Tea";
    homepage = "https://github.com/asheshgoplani/agent-deck";
    changelog = "https://github.com/asheshgoplani/agent-deck/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "agent-deck";
  };
}
