{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "hoarder-miniflux-webhook";
  version = "0-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "mathpn";
    repo = "hoarder-miniflux-webhook";
    rev = "98ec1d96306bcc2fe79bdb67ea06c0e6cf4f05ca";
    hash = "sha256-+SM/SzzrATlZgSvUOY9JdZIz1sYRLzwbDVXTjGYjDvw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/devusb/hoarder-miniflux-webhook/commit/60cacc8172bf2864b8e3b0f8179831dc3f573270.patch";
      hash = "sha256-PekDP3qyMEiAFV+xUIrOxAvSpa9D3y51sAAQOoJaQfo=";
    })
  ];

  vendorHash = "sha256-NHTKwUSIbNCUco88JbHOo3gt6S37ggee+LWNbHaRGEs=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/hoarder-miniflux-webhook
  '';

  meta = {
    description = "Simple service to integrate Hoarder with Miniflux using a webhook";
    homepage = "https://github.com/mathpn/hoarder-miniflux-webhook";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "hoarder-miniflux-webhook";
  };
}
