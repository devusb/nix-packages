{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  writeTextFile,
  cmake,
  boost,
  glew,
  imgui,
  nlohmann_json,
  pkg-config,
  SDL2,
  SDL2_net,
  spdlog,
  stormlib,
  tinyxml-2,
  libpng,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libpulseaudio,
  libzip,
  zenity,
}:

let
  imgui' = imgui.overrideAttrs rec {
    version = "v1.90.6";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "${version}-docking";
      hash = "sha256-Y8lZb1cLJF48sbuxQ3vXq6GLru/WThR78pq7LlORIzc=";
    };
  };

  stormlib' = stormlib.overrideAttrs (old: rec {
    version = "9.25";
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      tag = "v${version}";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkg-config ];
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        name = "stormlib-optimizations.patch";
        url = "https://github.com/briaguya-ai/StormLib/commit/ff338b230544f8b2bb68d2fbe075175ed2fd758c.patch";
        hash = "sha256-Jbnsu5E6PkBifcx/yULMVC//ab7tszYgktS09Azs5+4=";
      })
    ];
  });

  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
    hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

  stb_headers = fetchurl {
    name = "stb_image.h";
    url = "https://github.com/nothings/stb/raw/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h";
    hash = "sha256-xUsVponmofMsdeLsI6+kQuPg436JS3PBl00IZ5sg3Vw=";
  };

  stb_impl = writeTextFile {
    name = "stb_impl.c";
    text = ''
      #define STB_IMAGE_IMPLEMENTATION
      #include "stb_image.h"
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "Starship";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Starship";
    rev = "v${version}";
    hash = "sha256-kaLLlLuonqE2DJcRlWR4tCEBNjwIYFlzeDLcYsvMO7I=";
    fetchSubmodules = true;
  };

  patches = [
    ./deps.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    glew
    nlohmann_json
    SDL2
    SDL2_net
    stormlib'
    spdlog
    tinyxml-2
    libpng
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libpulseaudio
    libzip
    zenity
  ];

  hardeningDisable = [ "format" ];

  hardeningEnable = [ "pie" ];

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
  ];

  buildFlags = [
    "Starship"
  ];

  postPatch = ''
    mkdir -p build/_deps/stb  
    cp ${stb_headers} build/_deps/stb/${stb_headers.name}
    cp ${stb_impl} build/_deps/stb/${stb_impl.name}
  '';

  installPhase = ''
    runHook preInstall
    cmake --install .
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    install -Dm777 Starship $out/bin/Starship
  '';

  meta = {
    description = "SF64 PC Port";
    homepage = "https://github.com/HarbourMasters/Starship";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "Starship";
    platforms = lib.platforms.linux;
  };
}
