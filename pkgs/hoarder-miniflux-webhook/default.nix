{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "hoarder-miniflux-webhook";
  version = "0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "mathpn";
    repo = "hoarder-miniflux-webhook";
    rev = "0c78bee7b6c76321137005c4f13c316489d15e30";
    hash = "sha256-TLAG8JdQNrMwY73SwgY/Lp4LBPElobJUBYz8L2ktiTQ=";
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
