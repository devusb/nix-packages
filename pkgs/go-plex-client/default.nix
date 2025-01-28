{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "go-plex-client";
  version = "0-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "jrudio";
    repo = "go-plex-client";
    rev = "943dc7a39f7cc06d12497f0a465b486d39e39ff1";
    hash = "sha256-TXzhS0iML2EFP6xLWLi8QiMoYZZ/6a5mPEH7v1ASaMY=";
  };

  vendorHash = "sha256-vRp3h+6GWSfmdz0LDO1mJnwU1kjUUUXsIwUsZM9aLIQ=";

  patches = [
    # patch to add season downloading
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/jrudio/go-plex-client/pull/61.diff";
      hash = "sha256-L5jWdtJcy/13gNLImtqTSBeV1Avl8bLtUj8JaPss7kM=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/plex-cli
  '';

  doCheck = false;

  meta = with lib; {
    description = "A Plex.tv and Plex Media Server Go client";
    homepage = "https://github.com/jrudio/go-plex-client";
    maintainers = with maintainers; [ devusb ];
    mainProgram = "plex-cli";
  };
}
