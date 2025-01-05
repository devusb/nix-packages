{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  curl,
  SDL2,
}:

let
  dreammIcon = fetchurl {
    url = "https://aarongiles.com/dreamm/docs/icons/dreamm_icon.png";
    hash = "sha256-vPRIABG2EUqpGAqJkSHknUI5g/aF/stbcftGGWE8wfs=";
    name = "dreamm_icon.png";
  };
in
stdenv.mkDerivation rec {
  pname = "dreamm";
  version = "3.0.3";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-lVgt0SVm8ml1nFTDXnXpaYRI+1HDVwtLIztAq+re00E=";
        aarch64-linux = "sha256-zG/8ie3p9WI7D5ukVp8cQm+zhWysnzQ8qG5vrHIdyLs=";
      };
    in
    fetchzip {
      url = "https://aarongiles.com/dreamm/releases/dreamm-${version}-${suffix}.tgz";
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
  ];

  installPhase = ''
    runHook preInstall
    install -D dreamm $out/bin/dreamm
    install -D mt32emu-dreamm.so $out/lib/mt32emu-dreamm.so
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "dreamm";
      desktopName = "DREAMM";
      comment = "Bespoke emulator for LucasArts games";
      icon = dreammIcon;
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
    homepage = "https://aarongiles.com/dreamm/";
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
