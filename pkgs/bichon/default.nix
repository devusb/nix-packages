{
  lib,
  rustPlatform,
  stdenvNoCC,
  fetchFromGitHub,
  curl,
  git,
  pkg-config,
  pnpm,
  nodejs,
  openssl,
  zlib,
  zstd,
  stdenv,
  darwin,
}:

let
  pname = "bichon";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rustmailer";
    repo = "bichon";
    rev = version;
    hash = "sha256-xp5bjdbstnBPVZUNFqDa5SRKsrhPilVjWwJLGHEOD8Y=";
    leaveDotGit = true;
  };

  bichon-web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "bichon-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 1;
      hash = "sha256-syXO7Wvvp5yfqqzoWIRHITWY7Y9hjEd4Dwmw1zwWhZw";
    };
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];
    buildPhase = ''
      runHook preBuild
      pnpm -C web build
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-X5ifE0hzE8b3NvGbdOvgF67dVrDzhCYnQs2Q7caetwI=";

  nativeBuildInputs = [
    curl
    pkg-config
    git
  ];

  buildInputs = [
    curl
    openssl
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  preBuild = ''
    cp -r ${bichon-web} web/dist
  '';

  doCheck = false;

  meta = {
    description = "Bichon – A lightweight, high-performance Rust email archiver with WebUI";
    homepage = "https://github.com/rustmailer/bichon";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "bichon";
  };
}
