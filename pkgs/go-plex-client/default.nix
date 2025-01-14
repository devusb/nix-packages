{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "go-plex-client";
  version = "0-unstable-2023-05-08";

  src = fetchFromGitHub {
    owner = "jrudio";
    repo = "go-plex-client";
    rev = "834554e41d30eef59205fb43221dda92d8dbebd1";
    hash = "sha256-ulPMaScJrysAo1uuNzc+wCzKoBvmK8LZ2HNsyiqYMDE=";
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
