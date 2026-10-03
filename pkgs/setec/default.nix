{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "bc168fdb236279b5c5a43d14685df674d7fefb35";
    hash = "sha256-KxMYxRGFXvgQwaJiUb28J9nBDvplpTG/ZCbCr3Upq2E=";
  };

  vendorHash = "sha256-OWW4+k/+tpAn5N4w0/5peEpGwbIHVyXp2m857JVKuFs=";

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
