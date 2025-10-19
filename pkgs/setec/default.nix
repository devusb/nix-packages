{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "bc7a01a47c9cda0acbff2a49eda50708f59a47b1";
    hash = "sha256-cDMEiGKDSVeOD2zvvTs5h7Dm5j4F/eYj4wRA4aO+uK0=";
  };

  vendorHash = "sha256-nNGtys0IPwk+7zrQt3EYkJW0/1D4eOHEfAgBFK6fwyc=";

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
