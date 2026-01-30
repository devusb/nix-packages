{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "agent-deck";
  version = "0.8.97";

  src = fetchFromGitHub {
    owner = "asheshgoplani";
    repo = "agent-deck";
    rev = "v${version}";
    hash = "sha256-IRT0mFk5rm6+T7v8arhwcn7E8P82CQ2de+MwD8k0mdA=";
  };

  vendorHash = "sha256-r//Rgm41hwJHZ7T5mkOKB+xEsTOqMkI3iY0iOUDnjTM=";

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
