{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  miniz,
  spdlog,
  tinyxml-2,
  yaml-cpp,
  buildLibrary ? false,
}:

let
  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
    hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
  };
in
stdenv.mkDerivation {
  pname = "torch";
  version = "1.0.0-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Torch";
    rev = "cc3063afe6168bb19bc5b37580716e2b2465c87d";
    hash = "sha256-GwrJq5ORc7WEWpbdRl0LjeJYUzf3TLZAMThstTIZr44=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    miniz
    spdlog
    tinyxml-2
    yaml-cpp
  ];

  cmakeFlags =
    [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cpp.src}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2}")
    ]
    ++ lib.optionals buildLibrary [
      (lib.cmakeBool "USE_STANDALONE" false)
    ];

  postInstall =
    if buildLibrary then
      ''
        install -Dm644 libtorch.a $out/lib/libtorch.a
      ''
    else
      ''
        install -Dm777 torch $out/bin/torch
      '';

  meta = {
    description = "A generic asset processor for games";
    homepage = "https://github.com/HarbourMasters/Torch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "torch";
    platforms = lib.platforms.linux;
  };
}
