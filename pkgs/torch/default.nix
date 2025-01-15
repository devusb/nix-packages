{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libzip,
  spdlog,
  tinyxml-2,
  yaml-cpp,
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
  version = "1.0.0-unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Torch";
    rev = "94be71101cf5a81685949a6025a3870f2d798284";
    hash = "sha256-4ZYWajNqzamVo/2GoRlHU3tKGGn70onzUUie5ZM8RQQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libzip
    spdlog
    tinyxml-2
    yaml-cpp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBZIP" "${libzip}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2}")
  ];

  hardeningDisable = [ "format" ];

  hardeningEnable = [ "pie" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "libzip::zip" "libzip"
  '';

  meta = {
    description = "A generic asset processor for games";
    homepage = "https://github.com/HarbourMasters/Torch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "torch";
    platforms = lib.platforms.all;
  };
}
