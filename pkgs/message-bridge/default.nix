{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "message-bridge";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/dremin/message-bridge/releases/download/v${version}/MessageBridge.zip";
    hash = "sha256-T3VNDj2JBrPos+1SgiuRzS5MmoTd7fJNwAPsr7qvWdM=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share

    cp -R * $out/share

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper $out/share/bin/MessageBridge \
      $out/bin/MessageBridge \
      --chdir $out/share

    runHook postFixup
  '';

  meta = {
    description = "A solution for accessing iMessage and SMS chats from older computers, implemented as a REST API with a web-based client";
    homepage = "https://github.com/dremin/message-bridge";
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "MessageBridge";
    platforms = lib.platforms.darwin;
  };
}
