{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "f95fcfa391ae43a09b5d7f9963bae2558e9d1619";
    hash = "sha256-AX5sGam56GPj/0K2womyq5mvULhg255aRfyLeyr+d4A=";
  };

  vendorHash = "sha256-wOooQAoeTUox1l7YdKFTcZqCeOT00Erv3uvSduNVIag=";

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
