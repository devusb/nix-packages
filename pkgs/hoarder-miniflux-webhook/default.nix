{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "hoarder-miniflux-webhook";
  version = "0-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "mathpn";
    repo = "hoarder-miniflux-webhook";
    rev = "7c81f23f45409de80de84e5a2b2afa6fbaf0bec0";
    hash = "sha256-RpifUa8EN+AOMp6kRl2KRdYplRo5DVgKLGvSqUg1JpM=";
  };

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
