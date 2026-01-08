{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-01-07";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "51c689d4e60add21baafa1a67ae064eb52322749";
    hash = "sha256-C7g8z83JgsRAo+Bpabe6nqQ5dPXWjEsY6oGrlLRP4Ds=";
  };

  vendorHash = "sha256-2IbyZHbN14ieLQWmry3+EVgX4ZL7uubELtcksEGNkt0=";

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
