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
  version = "0.12.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abrauchli";
    repo = "usbeehive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TShsv/1zn3/0418ubljUmPsdQgSaiN3uaQjMOnHZTYU=";
  };

  cargoHash = "sha256-+Gn3jfaVuJxzjsllKIja41duSkK05X/X/PaSJPS2qwE=";

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
