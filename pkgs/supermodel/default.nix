{ lib
, stdenv
, fetchFromGitHub
, zlib
, mesa
, SDL2
, mesa_glu
, SDL2_net
}:

stdenv.mkDerivation {
  pname = "supermodel";
  version = "unstable-2024-01-29";

  src = fetchFromGitHub {
    owner = "trzy";
    repo = "Supermodel";
    rev = "e59ecea32d8ca20caf55662e698665f5b9142808";
    hash = "sha256-OU83/yzn3TL8R9ZjiNEZqn5aTB0Bt/G7C+tywb4qedQ=";
  };

  buildInputs = [
    zlib
    mesa
    SDL2
    mesa_glu
    SDL2_net
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=format-security" ];

  buildPhase = ''
    make -f 'Makefiles/Makefile.UNIX'
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share

    install -Dm755 bin/supermodel $out/bin/supermodel
    cp -r Config $out/share
    cp -r Assets $out/share
  '';

  meta = with lib; {
    description = "Official repository of the Sega Model 3 arcade emulator";
    homepage = "https://github.com/trzy/Supermodel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "supermodel";
    platforms = platforms.linux;
  };
}
