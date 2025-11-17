{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "aca8be938abc7c01625a389cddcc96d4d9b9de7c";
    hash = "sha256-3a8/nOXUTnifOY1P48A/1tT/Mb6y5V2GXZOfG35Cits=";
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
