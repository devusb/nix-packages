{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "22930071e0cc2c0b2667039e5cf913164aa7454f";
    hash = "sha256-s4JwQRVmPK5g9gF3UjyPGX5PilCsjdYSZQs0v8Aqd+s=";
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
