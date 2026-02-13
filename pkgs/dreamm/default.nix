{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  autoAddDriverRunpath,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  curl,
  SDL2,
  libgbm,
  libxcb,
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
  version = "4.0b17";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux-x64";
        aarch64-linux = "linux-arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-FY7wCiNv86NeKkV/nB+Ty5yAIO7VClNm3rpRaDqjie8=";
        aarch64-linux = "";
      };
    in
    fetchzip {
      url = "https://aarongiles.com/dreamm/releases/4.0/dreamm-${version}-${suffix}.tgz";
      inherit hash;
      stripRoot = false;
    };

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    curl
    SDL2
  ];

  runtimeDependencies = [
    libgbm
    libxcb
  ];

  installPhase = ''
    runHook preInstall
    install -D dreamm $out/bin/dreamm
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
