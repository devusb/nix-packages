{ lib
, stdenv
, fetchFromGitHub
, cmake
, alsa-lib
, SDL2
}:

stdenv.mkDerivation {
  pname = "raptor";
  version = "unstable-0.8.0-2024-05-02";

  src = fetchFromGitHub {
    owner = "skynettx";
    repo = "raptor";
    rev = "e8d838c6db77084a6fb7f37b41de669fbf68b808";
    hash = "sha256-JwtbLdxskPsg9iEVKUYz6P9W4IRNqjF1LDsp+Y3YUuI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    alsa-lib
    SDL2
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "SDL2::SDL2main" ""
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bin/raptor $out/bin
    cp "$src/SETUP(MIDI).INI" $out/bin/SETUP.INI
    cp $src/include/TimGM6mb/TimGM6mb.sf2 $out/bin/SoundFont.sf2
    ln -s ${./FILE0000.GLB} $out/bin/FILE0000.GLB
    ln -s ${./FILE0001.GLB} $out/bin/FILE0001.GLB
    ln -s ${./FILE0002.GLB} $out/bin/FILE0002.GLB
    ln -s ${./FILE0003.GLB} $out/bin/FILE0003.GLB
    ln -s ${./FILE0004.GLB} $out/bin/FILE0004.GLB

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reversed-engineered source port from Raptor Call Of The Shadows";
    homepage = "https://github.com/skynettx/raptor?tab=readme-ov-file";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "raptor";
    platforms = platforms.all;
  };
}
