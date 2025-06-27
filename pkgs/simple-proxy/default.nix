{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple-proxy";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jthomperoo";
    repo = "simple-proxy";
    rev = "v${version}";
    hash = "sha256-O6SNyEetKQp2B3ntQpX2AJzqb43edbL9KBt/Z9Yfl28=";
  };

  vendorHash = "sha256-VYHx8P6uq6TZA0SlHcjKrBP4VVjYWZUl9dZ+pwUkqrU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple HTTP/HTTPS proxy - designed to be distributed as a self-contained binary that can be dropped in anywhere and run";
    homepage = "https://github.com/jthomperoo/simple-proxy";
    changelog = "https://github.com/jthomperoo/simple-proxy/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "simple-proxy";
  };
}
