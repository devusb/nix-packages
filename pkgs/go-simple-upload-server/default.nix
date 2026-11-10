{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-Lbe83YvAINw//pgHwFlOWfCws31KCu3woEMkSvwLmEo=";
  };

  vendorHash = "sha256-+ZPik/uA2e367Zu6GY3lXqVZuBVB3NmkPzuENiPGCqs=";

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
