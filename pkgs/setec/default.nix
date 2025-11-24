{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "db98deb54537046ce25af75b5c49c3fcff54ce36";
    hash = "sha256-Y6iCUnqcrMugHkhGlXTanJgPsqIAcrAROx6+Mv8wvWs=";
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
