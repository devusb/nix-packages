# Packaging derived from xaltsc/jellyfin-desktop
{
  lib,
  stdenv,
  symlinkJoin,
  cef-binary,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  writers,
  libGL,
  ffmpeg,
  libxkbcommon,
  libxcb,
  mpv-unwrapped,
  nix-update-script,
}:
let
  cef' = cef-binary.override {
    version = "152.0.8";
    gitRevision = "1ce985c";
    chromiumVersion = "152.0.7977.134";
    srcHashes = {
      aarch64-linux = "sha256-mY8qMQ0Qhivf+Tc83IP5QVef0f+uW1jYFZpFVOFTSaE=";
      x86_64-linux = "sha256-f0fuscKXCZ/7nhLQ3qag1Oq9JVE10RT/Cs6HgL2z/us=";
    };
  };

  cefArchive = writers.writeJSON "archive.json" {
    type = "minimal";
    name = baseNameOf cef'.src.url;
    sha1 = "";
  };

  # CEF resolves icudtl.dat from the realpath of libcef.so, so Release and
  # Resources are copied into one directory rather than symlinked
  cef-lib = stdenv.mkDerivation {
    pname = "cef-lib";
    inherit (cef') version;
    dontUnpack = true;
    stripDebugList = [ "." ];
    installPhase = ''
      mkdir -p $out
      cp -r ${cef'}/Release/* $out/
      cp -r ${cef'}/Resources/* $out/
      cp -r ${cef'}/include $out/
      cp ${cefArchive} $out/archive.json
    '';
  };
  # xtask's --external-mpv expects one prefix with both lib/ and include/
  mpv-external-prefix = symlinkJoin {
    pname = "mpv-external-prefix";
    inherit (mpv-unwrapped) version;
    paths = [
      (lib.getDev mpv-unwrapped)
      (lib.getLib mpv-unwrapped)
    ];
  };
in
rustPlatform.buildRustPackage {
  pname = "jellium-desktop";
  version = "0-unstable-2026-10-19";

  src = fetchFromGitHub {
    owner = "andrewrabert";
    repo = "jellium-desktop";
    rev = "1b73a13b32e427c27815dac48b0bd82de771f454";
    hash = "sha256-7zEw1lHD6Rk06dGNGbZHbly+7hKg2UqTnPFIzG5oeCI=";
  };

  patches = [
    (fetchpatch {
      name = "screensaver-idle-inhibit.patch";
      url = "https://github.com/devusb/jellium-desktop/commit/146a638cbcc57c83e4fc0988964d3837ffb831de.patch";
      hash = "sha256-unPV8WRoMSb0d0RK2pbZXaCC45CULjjBBeki3RRAD7o=";
    })
  ];

  cargoRoot = "src";
  cargoHash = "sha256-RuF7Jb/7Xy/iaHdzaaNUksvdZutE6E89Gb2Mn1Af+6k=";

  strictDeps = true;

  nativeBuildInputs = [
    wrapGAppsHook4
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    libxcb
    libxkbcommon
    ffmpeg
  ];

  buildPhase = ''
    runHook preBuild
    cargo xtask build \
      --cef-path ${cef-lib} \
      --external-mpv ${mpv-external-prefix} \
      --out build/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/jellium-desktop $out/bin/jellium-desktop

    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.desktop \
      $out/share/applications/net.nullsum.JelliumDesktop.desktop
    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.metainfo.xml \
      $out/share/metainfo/net.nullsum.JelliumDesktop.metainfo.xml
    install -Dm644 resources/linux/net.nullsum.JelliumDesktop.svg \
      $out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"
    )
  '';

  doCheck = false;

  # jellium links libcef at runtime; a cef-binary that does not match the `cef`
  # crate ABI builds cleanly but aborts on startup
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/jellium-desktop" --version | grep -F "CEF ${cef'.version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Unofficial Jellyfin desktop client built on CEF and mpv";
    homepage = "https://github.com/andrewrabert/jellium-desktop";
    license = lib.licenses.gpl2Only;
    mainProgram = "jellium-desktop";
    maintainers = with lib.maintainers; [ devusb ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
