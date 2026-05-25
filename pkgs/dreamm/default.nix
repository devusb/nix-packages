{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  curl,
  SDL2,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "dreamm";
  version = "4.0";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-ngkoR1sY7x9oiqA8eIbiL2UveCx3H5Lzk52u7PIDmGk=";
        aarch64-linux = "sha256-qDMzaZh4hrRBo7aKDW0TUO+zNZqT6x9cmiF/jx76+Oo=";
      };
    in
    fetchzip {
      url = "https://dreamm.aarongiles.com/releases/dreamm-${version}-${suffix}.tgz";
      inherit hash;
      stripRoot = false;
    };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    curl
    SDL2
    util-linux
  ];

  installPhase = ''
    runHook preInstall
    install -D dreamm $out/bin/dreamm
    install -Dm644 dreamm.png $out/share/icons/hicolor/256x256/apps/dreamm.png
    install -Dm644 readme.txt $out/share/doc/dreamm/readme.txt
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "dreamm";
      desktopName = "DREAMM";
      comment = "Bespoke emulator for LucasArts games";
      icon = "dreamm";
      exec = "dreamm";
      categories = [
        "Game"
        "Emulator"
      ];
      keywords = [
        "Star"
        "Wars"
        "Lucas"
        "Arts"
        "Emulator"
        "Indiana"
        "Jones"
      ];
    })
  ];

  meta = {
    description = "Bespoke emulator for LucasArts games";
    homepage = "https://dreamm.aarongiles.com/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = with lib.licenses; [
      bsd3
      mit
      ftl
      zlib
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "dreamm";
    platforms = lib.platforms.linux;
  };
}
