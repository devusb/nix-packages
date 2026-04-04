{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bluebubbles-tui";
  version = "0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "oovets";
    repo = "bluebubbles-tui";
    rev = "10f516865e40e947646f727427bad86e17327659";
    hash = "sha256-1p6p6QKE679Rvw3hfc6K9nFOWN80c65bY5N6ekzNljQ=";
  };

  vendorHash = "sha256-VVGl+sm1l8X6D/oi7M6c7MxO9Z0n9JhZbYq1GknHV6E=";

  ldflags = [ "-s" ];

  meta = {
    description = "A sleek, real-time terminal user interface (TUI) for BlueBubbles, allowing you to send and receive iMessages directly from your terminal";
    homepage = "https://github.com/oovets/bluebubbles-tui";
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "bluebubbles-tui";
  };
})
