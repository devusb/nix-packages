{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-03-10";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "dcd97e42f2518bc1d304089a5380fa6ad4c03602";
    hash = "sha256-55jpSpyyrfwtt6vVg8ZElnK4unaBJZXtKhRBr3EsrN4=";
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
