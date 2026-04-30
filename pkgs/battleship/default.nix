{ lib
, fetchFromGitHub
, applyPatches
, writeTextFile
, fetchurl
, stdenv
, replaceVars
, srcOnly
, cmake
, makeWrapper
, ninja
, pkg-config
, python3
, zip
, libGL
, libzip
, nlohmann_json
, SDL2
, spdlog
, tinyxml-2
, glew
, libx11
, libxrandr
, libxinerama
, libxcursor
, libxi
, requireFile
, rom ? requireFile {
    name = "baserom.us.z64";
    url = "https://github.com/JRickey/BattleShip";
    hash = "sha256-FVkuedPFKVzvQ3HUmS8L0lvsIQL8KWRMk+aC9+qZ7z0=";
    message = ''
      baserom.us.z64 not found in the store. Acquire a US SSB64 ROM and run:

        nix-store --add-fixed sha256 baserom.us.z64
    '';
  }
}:

let
  lusCommit = "39cbe9e6b05c762b87da13db8ccc4876aa7a4ef2";

  imgui' = applyPatches {
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v1.91.9b-docking";
      hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
    };
    patches = [
      (fetchurl {
        url = "https://raw.githubusercontent.com/JRickey/libultraship/${lusCommit}/cmake/dependencies/patches/imgui-fixes-and-config.patch";
        hash = "sha256-2/ydFGyEmllMREvEJE8j3WMYBrzCq3l2KqhjHnRYv6g=";
      })
    ];
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

  prism = fetchFromGitHub {
    owner = "KiritoDv";
    repo = "prism-processor";
    rev = "1de054450e7b3c5f777d2e3dfcb228ad120c329d";
    hash = "sha256-5MlscqbKlUm4nYW+Obf5KlnUdtHK/xlDUc4wxr52ySM=";
  };

  stb' = fetchurl {
    name = "stb_image.h";
    url = "https://raw.githubusercontent.com/nothings/stb/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h";
    hash = "sha256-xUsVponmofMsdeLsI6+kQuPg436JS3PBl00IZ5sg3Vw=";
  };

  stb_impl = writeTextFile {
    name = "stb_impl.c";
    text = ''
      #define STB_IMAGE_IMPLEMENTATION
      #include "stb_image.h"
    '';
  };

  torch-libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
    hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
  };

  torch-spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "79524ddd08a4ec981b7fea76afd08ee05f83755d";
    hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
  };

  torch-yaml-cpp = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "2f86d13775d119edbb69af52e5f566fd65c6953b";
    hash = "sha256-GtUTbEaRR3+GfVkt3t8EsqBHVffVKOl8urtQTaHozIo=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "battleship";
  version = "0-unstable-2026-04-30";

  src = fetchFromGitHub {
    owner = "JRickey";
    repo = "BattleShip";
    rev = "bec6baa";
    hash = "sha256-kSZTQoSgURAifXR7b/Q8Fzs2393/yXcJaHZUvTsinZI=";
    fetchSubmodules = true;
  };

  patches = [
    ./target-fps-cvar.patch
    ./dont-fetch-stb.patch
    (replaceVars ./torch-deps.patch {
      libgfxd_src = torch-libgfxd;
      spdlog_src = torch-spdlog;
      yaml-cpp_src = srcOnly torch-yaml-cpp;
      tinyxml2_src = srcOnly tinyxml-2;
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
    zip
  ];

  buildInputs = [
    libGL
    libzip
    nlohmann_json
    SDL2
    spdlog
    tinyxml-2
    glew
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "NON_MATCHING" true)
    (lib.cmakeBool "NON_EQUIVALENT" true)
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
  ];

  strictDeps = true;
  hardeningDisable = [ "format" ];

  preConfigure = ''
    # STB: patch points STB_DIR to source-root/stb, so populate it
    mkdir -p stb
    cp ${stb'} ./stb/${stb'.name}
    cp ${stb_impl} ./stb/${stb_impl.name}

    pushd src/credits
    for f in staff.credits.us.txt titles.credits.us.txt; do
      python3 ../../tools/creditsTextConverter.py "$f"
    done
    for f in info.credits.us.txt companies.credits.us.txt; do
      python3 ../../tools/creditsTextConverter.py -paragraphFont "$f"
    done
    popd
  '';

  postBuild = ''
    ( cd ../libultraship/src/fast && zip -rq $PWD/f3d.o2r shaders )
    mv ../libultraship/src/fast/f3d.o2r ./f3d.o2r

    ./TorchExternal/src/TorchExternal-build/torch pack ../assets ssb64.o2r o2r
  '' + lib.optionalString (rom != null) ''
    # Extract ROM assets at build time
    ( cd .. && build/TorchExternal/src/TorchExternal-build/torch o2r ${rom} )
    cp ../BattleShip.o2r ./BattleShip.o2r
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/battleship}
    install -Dm755 BattleShip $out/bin/BattleShip
    install -Dm755 TorchExternal/src/TorchExternal-build/torch $out/bin/battleship-torch
    ln -s battleship-torch $out/bin/torch
    install -Dm644 -t $out/share/battleship \
      f3d.o2r \
      ssb64.o2r \
      ../gamecontrollerdb.txt \
      ../config.yml
    cp -r ../yamls $out/share/battleship/
    ${lib.optionalString (rom != null) "install -Dm644 BattleShip.o2r $out/share/battleship/BattleShip.o2r"}

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/BattleShip \
      --prefix PATH : "$out/bin" \
      --run 'mkdir -p ~/.local/share/BattleShip' \
      --run "ln -sf $out/share/battleship/f3d.o2r ~/.local/share/BattleShip/f3d.o2r" \
      --run "ln -sf $out/share/battleship/ssb64.o2r ~/.local/share/BattleShip/ssb64.o2r" \
      --run "test -f $out/share/battleship/BattleShip.o2r && ln -sf $out/share/battleship/BattleShip.o2r ~/.local/share/BattleShip/BattleShip.o2r || true" \
      --run "ln -sf $out/share/battleship/gamecontrollerdb.txt ~/.local/share/BattleShip/gamecontrollerdb.txt" \
      --run "cp -f $out/share/battleship/config.yml ~/.local/share/BattleShip/config.yml 2>/dev/null || true" \
      --run "chmod -R u+w ~/.local/share/BattleShip/yamls 2>/dev/null; rm -rf ~/.local/share/BattleShip/yamls && cp -rL --no-preserve=mode $out/share/battleship/yamls ~/.local/share/BattleShip/yamls" \
      --run 'cd ~/.local/share/BattleShip'

    wrapProgram $out/bin/battleship-torch \
      --run 'cd ~/.local/share/BattleShip'
  '';

  meta = {
    homepage = "https://github.com/JRickey/BattleShip";
    description = "Super Smash Bros. 64 PC port";
    mainProgram = "BattleShip";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = with lib.licenses; [ mit cc0 unfree ];
  };
})
