{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "dd66b9ef67329cc2ec54efd98c7943f83ccee42d";
    hash = "sha256-7/K7QZHdiJoysnkdAyL8U6t38FNgMIGe/wW0iRuqBDY=";
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
