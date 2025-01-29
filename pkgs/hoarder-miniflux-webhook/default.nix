{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "hoarder-miniflux-webhook";
  version = "0-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "mathpn";
    repo = "hoarder-miniflux-webhook";
    rev = "142a827a9729dafaacfc2a2aa25c66f9d857acef";
    hash = "sha256-zqf/2lWDbLZcSO7wrDJlNMTjrGG+NA7uwjs45SqGgd4=";
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
