{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "e5a2e49f058b86588e54502ff5b350c719d35eef";
    hash = "sha256-6KoU0b7O9m5TC7QT2I23y+gXxDVHVvqWBguuKOnaEzw=";
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
