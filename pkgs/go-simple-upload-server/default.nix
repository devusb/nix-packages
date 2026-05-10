{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-auzlL3tEx9yeml0r1BXJXqntLRPNQtYrf1KGcjNoo1E=";
  };

  vendorHash = "sha256-T/DXlhBE8TE6TnNQVuZE81jQedLyQZzDhJPGL4y2zew=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Simple HTTP server to save artifacts";
    homepage = "https://github.com/mayth/go-simple-upload-server";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "go-simple-upload-server";
  };
}
