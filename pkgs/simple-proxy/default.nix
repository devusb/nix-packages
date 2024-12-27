{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "simple-proxy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jthomperoo";
    repo = "simple-proxy";
    rev = "v${version}";
    hash = "sha256-vqLxpW2Vi8omSMOXUNxV75c9U7k1qhyU0nQiv7IIvPs=";
  };

  vendorHash = "sha256-5PN6a66hKWlqRVFQU+0c0fqVMAstUje0W25on30dpaM=";

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
