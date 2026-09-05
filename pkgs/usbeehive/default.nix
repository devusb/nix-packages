{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbeehive";
  version = "0.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abrauchli";
    repo = "usbeehive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5aqEqt0zwzG4O+roq0p4vs59z7s2ERPE+FzyW9waegw=";
  };

  cargoHash = "sha256-YX72/E1N59U6EU54SWpL8Ew/eMelAjnBF7xqpLYCNIo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tells you what each USB cable / device on Linux can actually do. Rust port of WhatCable; previously published as `whatcable";
    homepage = "https://github.com/abrauchli/usbeehive";
    changelog = "https://github.com/abrauchli/usbeehive/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "usbeehive";
    platforms = lib.platforms.linux;
  };
})
