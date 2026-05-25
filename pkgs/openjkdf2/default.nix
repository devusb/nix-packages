{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3Packages,
  bison,
  # System libs the engine and its vendored bits link against
  SDL2,
  SDL2_mixer,
  openal,
  glew,
  libpng,
  zlib,
  physfs,
  libGL,
  curl,
  gtk3,

  # Build-time toggles
  enableGameNetworkingSockets ? false,
  enableMultiplayerMenus ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openjkdf2";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "shinyquagsire23";
    repo = "OpenJKDF2";
    rev = "v${finalAttrs.version}";
    # Submodules are still fetched: only libpng/zlib/SDL/SDL_mixer/physfs/
    # openal/glew/freeglut/GNS/protobuf are replaced by system libs via cmake
    # shims below. Vendored libsmacker/libsmusher/mbedtls live under
    # src/external/ (not submodules) and are still used.
    fetchSubmodules = true;
    hash = "sha256-axqJ0tPKB1zwH26ovatef7SvShsIZlJFtp80iaEFy3k=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bison
    python3Packages.cogapp
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    openal
    glew
    libpng
    zlib
    physfs
    libGL
    curl
    gtk3
  ];

  postPatch = ''
    # Disable Steam multiplayer — pulls in protobuf + GNS ExternalProject
    # chain unsuited to a sealed nix build, and irrelevant on a handheld.
    ${lib.optionalString (!enableGameNetworkingSockets) ''
      substituteInPlace cmake_modules/plat_feat_full_sdl2.cmake \
        --replace-fail \
          'set(TARGET_USE_GAMENETWORKINGSOCKETS TRUE)' \
          'set(TARGET_USE_GAMENETWORKINGSOCKETS FALSE)'
    ''}

    # Replace each vendored-lib ExternalProject with a shim that consumes the
    # nixpkgs version via pkg-config and re-exports upstream's target names.
    # pkg-config sidesteps the nixpkgs split-output problem that breaks cmake
    # config files (libdir paths baked into Config.cmake) and the FindFoo
    # module-vs-config mode confusion.
    cat > cmake_modules/build_zlib.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(ZLIB_PC REQUIRED IMPORTED_TARGET zlib)
    if(NOT TARGET ZLIB::ZLIB)
      add_library(ZLIB::ZLIB INTERFACE IMPORTED)
      target_link_libraries(ZLIB::ZLIB INTERFACE PkgConfig::ZLIB_PC)
    endif()
    EOF

    cat > cmake_modules/build_libpng.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PNG_PC REQUIRED IMPORTED_TARGET libpng)
    if(NOT TARGET PNG::PNG)
      add_library(PNG::PNG INTERFACE IMPORTED)
      target_link_libraries(PNG::PNG INTERFACE PkgConfig::PNG_PC)
    endif()
    EOF

    cat > cmake_modules/build_physfs.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PHYSFS_PC REQUIRED IMPORTED_TARGET physfs)
    if(NOT TARGET PhysFS::PhysFS_s)
      add_library(PhysFS::PhysFS_s INTERFACE IMPORTED)
      target_link_libraries(PhysFS::PhysFS_s INTERFACE PkgConfig::PHYSFS_PC)
    endif()
    if(NOT TARGET PhysFS::PhysFS)
      add_library(PhysFS::PhysFS INTERFACE IMPORTED)
      target_link_libraries(PhysFS::PhysFS INTERFACE PkgConfig::PHYSFS_PC)
    endif()
    add_compile_definitions(PLATFORM_PHYSFS)
    EOF

    cat > cmake_modules/build_sdl.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2_PC REQUIRED IMPORTED_TARGET sdl2)
    if(NOT TARGET SDL::SDL)
      add_library(SDL::SDL INTERFACE IMPORTED)
      target_link_libraries(SDL::SDL INTERFACE PkgConfig::SDL2_PC)
    endif()
    EOF

    cat > cmake_modules/build_sdl_mixer.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2_MIXER_PC REQUIRED IMPORTED_TARGET SDL2_mixer)
    if(NOT TARGET SDL::Mixer)
      add_library(SDL::Mixer INTERFACE IMPORTED)
      target_link_libraries(SDL::Mixer INTERFACE PkgConfig::SDL2_MIXER_PC)
    endif()
    set(SDL_MIXER_DEPS "")
    EOF

    # GLEW: upstream calls find_package(GLEW 2.2.0) which on nixpkgs hits
    # CMake's bundled FindGLEW and can't locate GLEW_LIBRARIES through the
    # split outputs. Force it to use pkg-config too. The reference is
    # GLEW::GLEW (uppercase) in the link line.
    cat > cmake_modules/find_glew_shim.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GLEW_PC REQUIRED IMPORTED_TARGET glew)
    set(GLEW_FOUND TRUE)
    if(NOT TARGET GLEW::GLEW)
      add_library(GLEW::GLEW INTERFACE IMPORTED)
      target_link_libraries(GLEW::GLEW INTERFACE PkgConfig::GLEW_PC)
    endif()
    EOF

    substituteInPlace cmake_modules/config_platform_deps.cmake \
      --replace-fail \
        'find_package(GLEW 2.2.0)' \
        'include(''${CMAKE_SOURCE_DIR}/cmake_modules/find_glew_shim.cmake)'

    # freeglut is found via find_package(GLUT) but never actually link-target'd
    # on Linux — only included so FreeGLUT_FOUND is true. No-op the fallback.
    : > cmake_modules/build_freeglut.cmake

    # main.c → SDL2_helper.h pulls in <GL/glew.h>, but the openjkdf2 executable
    # only PRIVATE-links sith_engine + SDL2_COMMON_LIBS, so GLEW's INTERFACE
    # include dirs don't reach main.c. Also: upstream tries
    # add_dependencies(SDL::SDL SDL), which silently no-ops on IMPORTED targets
    # — wire any remaining ExternalProject targets (none in this config) to the
    # executable directly so ninja sees the producer.
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'target_link_libraries(''${BIN_NAME} PRIVATE ''${SDL2_COMMON_LIBS} sith_engine)' \
        'target_link_libraries(''${BIN_NAME} PRIVATE ''${SDL2_COMMON_LIBS} sith_engine GLEW::GLEW)'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "PLAT_LINUX_64" true)
    (lib.cmakeBool "TARGET_NO_MULTIPLAYER_MENUS" (!enableMultiplayerMenus))
  ];

  env.OPENJKDF2_RELEASE_COMMIT = "v${finalAttrs.version}";
  env.OPENJKDF2_RELEASE_COMMIT_SHORT = "v${finalAttrs.version}";

  installPhase = ''
    runHook preInstall
    install -Dm755 openjkdf2 $out/bin/openjkdf2
    runHook postInstall
  '';

  meta = {
    description = "Function-by-function reimplementation of Star Wars: Jedi Knight: Dark Forces II in C";
    homepage = "https://github.com/shinyquagsire23/OpenJKDF2";
    license = lib.licenses.mit;
    mainProgram = "openjkdf2";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ ];
  };
})
