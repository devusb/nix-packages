{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-12-10";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "d603572f1e1b02beff41deea8f6506ca1e803246";
    hash = "sha256-3+tTb6i8XY8AbJK/CF9VZGAR2Juh1lt3QMM1ouoYCNE=";
  };

  vendorHash = "sha256-weThrhvk0rMDc0Y4apei0nRlvuhsrCF2yU/EvFZtwn8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A secrets management service that uses Tailscale for access control";
    homepage = "https://github.com/tailscale/setec";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "setec";
  };
}
