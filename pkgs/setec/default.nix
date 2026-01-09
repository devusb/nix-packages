{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "e6ea558102fc39d65965056193a929a9ae0fdfac";
    hash = "sha256-380ATOl13b+SbWoBekXrlQ8sWqlYrgNMwfCMsQI/fbo=";
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
