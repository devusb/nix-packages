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
  version = "0.12.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abrauchli";
    repo = "usbeehive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zaGUIs/A6UXlsK8uSsMrsdTzQFfCDpsEmJB+lz2O7Pg=";
  };

  cargoHash = "sha256-4JO9WaVYvBBCt3hVdigMhXrtVOM5t7ZEvVgsOESTVhw=";

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
