{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-08-08";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "58bd74dcaa1a4e50589f5a3d0961cd30769246bd";
    hash = "sha256-8V8NwtZE+Ud5jW+4YO6hMruElaBQmvjG/tp+UTuVQx8=";
  };

  vendorHash = "sha256-VQ2fY3QyepDt0ymgFgEKB50zXezgu6Il6SL5lBJQjGA=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "A secrets management service that uses Tailscale for access control";
    homepage = "https://github.com/tailscale/setec";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "setec";
  };
}
