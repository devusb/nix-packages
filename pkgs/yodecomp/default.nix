{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  cmake,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  unzip,
  sdl3,
  retailData ? null,
}:

let
  full = retailData != null;

  # Needed to build any variant: its resources are embedded in the binary and
  # the decompiled code refers to them by id.
  demoArchive = fetchurl {
    url = "https://archive.org/download/StarWarsYodaStories_1020/YodaDemo.zip";
    hash = "sha256-dX+M5js8Kx22wN41GfWWyQi7If+alHG4bHHbMO2bR/U=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yodecomp" + lib.optionalString full "-full";
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "shinyquagsire23";
    repo = "Yodecomp";
    rev = "850368bc1727dcf2f690d78b10fc1fcd1c09f453";
    hash = "sha256-8kDJfajHue9Chq9Sk7gZ8L3WpnHkkWhKw91P2PWTnx0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/devusb/Yodecomp/commit/0871694bf693e3f5934239bc5ed481499e0f96c1.patch";
      hash = "sha256-3mkNREKwLjN8e7UwSmeHlU7Fg9rvDEMYLXPbF+3Ab2M=";
    })
    (fetchpatch {
      url = "https://github.com/devusb/Yodecomp/commit/ea2d8ab2e422bc6e23b688c13de8c47196494a16.patch";
      hash = "sha256-fVCE/2iGFNJZ8V4Wq1rK165DMMU65dlaanhEBd1Wq6Y=";
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
    unzip
  ];

  buildInputs = [ sdl3 ];

  postPatch = ''
    unzip -q ${demoArchive} -d .
  ''
  + lib.optionalString full ''
    unzip -q -o ${retailData} 'Yoda/*' -d retail
    install -Dm644 retail/Yoda/YODESK.EXE "Yoda Stories/Yodesk.exe"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "YODA_PLATFORM" "SDL")
    (lib.cmakeFeature "YODA_VARIANT" (if full then "FULL" else "DEMO"))
    # Yoda ships no MIDI, so core streams cover it and sdl3-mixer is not needed.
    (lib.cmakeFeature "YODA_MFX_AUDIO_BACKEND" "sdl3stream")
  ];

  installPhase = ''
    runHook preInstall

    # Not in bin: unusable without the environment the wrapper sets.
    install -Dm755 yoda $out/libexec/yodecomp/yoda
  ''
  # The engine appends the variant's own file name to its data directory.
  + (
    if full then
      ''
        install -Dm644 ../retail/Yoda/YODESK.DTA $out/share/yodecomp/YODESK.DTA
        install -Dm644 ../retail/Yoda/sfx/*.WAV -t $out/share/yodecomp/sfx
      ''
    else
      ''
        install -Dm644 ../YodaDemo/YodaDemo.dta $out/share/yodecomp/YODADEMO.DTA
        install -Dm644 ../YodaDemo/sfx/*.wav -t $out/share/yodecomp/sfx
      ''
  )
  + ''
    makeWrapper $out/libexec/yodecomp/yoda $out/bin/yodecomp \
      --set YODA_DATA_DIR $out/share/yodecomp

    runHook postInstall
  '';

  # Retail ships its sounds upper case and the data names them lower case.
  postFixup = ''
    for f in $out/share/yodecomp/sfx/*; do
      lower=$(dirname "$f")/$(basename "$f" | tr '[:upper:]' '[:lower:]')
      [ "$f" = "$lower" ] || mv "$f" "$lower"
    done
  '';

  meta = {
    description = "Decompilation of LucasArts' Desktop Adventures engine, SDL port";
    homepage = "https://github.com/shinyquagsire23/Yodecomp";
    # Engine source is CC0; the embedded resources and game data are LucasArts'.
    license = [
      lib.licenses.cc0
      lib.licenses.unfree
    ];
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryBytecode
    ];
    platforms = lib.platforms.linux;
    mainProgram = "yodecomp";
  };
})
