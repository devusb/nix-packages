# Packaging derived from xaltsc/jellyfin-desktop
{
  lib,
  stdenv,
  symlinkJoin,
  cef-binary,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  writers,
  libGL,
  ffmpeg,
  libxkbcommon,
  libxcb,
  mpv-unwrapped,
}:
let
  cefArchive = writers.writeJSON "archive.json" {
    type = "minimal";
    name = baseNameOf cef-binary.src.url;
    sha1 = "";
  };

  # CEF resolves icudtl.dat from the realpath of libcef.so, so Release and
  # Resources are copied into one directory rather than symlinked
  cef-lib = stdenv.mkDerivation {
    pname = "cef-lib";
    inherit (cef-binary) version;
    dontUnpack = true;
    stripDebugList = [ "." ];
    installPhase = ''
      mkdir -p $out
      cp -r ${cef-binary}/Release/* $out/
      cp -r ${cef-binary}/Resources/* $out/
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
  version = "0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "andrewrabert";
    repo = "jellium-desktop";
    rev = "28f2cf16a1f1b819884dd6a72919ca55bdf9bd73";
    hash = "sha256-fMk5bZRMi6FgTGigu3/fYX9sj1HmKW5mp+Ipc+BO+tQ=";
  };

  cargoRoot = "src";
  cargoHash = "sha256-JFFQjOw4Iu6NiQScQqYg/J7XEkLbHCDa+XS12VJJdVI=";

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
    "$out/bin/jellium-desktop" --version | grep -F "CEF ${cef-binary.version}"
    runHook postInstallCheck
  '';

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
