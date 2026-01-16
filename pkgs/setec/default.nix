{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-01-15";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "19d190c5556d6387252f8597bd987993eaf855e5";
    hash = "sha256-2QOM33VecX8VjeHluwlqs8OQRxQ7QUPQ+5cmB/CHxMU=";
  };

  vendorHash = "sha256-7JaOvBCETiqXj33YSY5ESIhH3Kp+NSCAAVkre8Zg0RA=";

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
