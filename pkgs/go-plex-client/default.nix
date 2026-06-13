{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-plex-client";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jrudio";
    repo = "go-plex-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fIy/MRCBd+epMUcbdTbQ6c6zOzZoFPCPZJCQzm/eMvg=";
  };

  vendorHash = "sha256-mvYkjEhcoalOzbq1WbRNQo01iA2m1ab44oylNzpVJCs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A Plex.tv and Plex Media Server Go client";
    homepage = "https://github.com/jrudio/go-plex-client";
    maintainers = with maintainers; [ devusb ];
    mainProgram = "plex-cli";
  };
})
