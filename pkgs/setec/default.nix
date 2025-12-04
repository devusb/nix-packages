{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "2ab774e4129a0640d84f533827a8871948db17ff";
    hash = "sha256-Ji4W9UOqjhvfT/H6I/UNWvhFBbA76PAfTQ+rB84C4D0=";
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
