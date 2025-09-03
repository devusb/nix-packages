{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "extest";
  version = "1.0.2-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = "0d068672fdaefd6f6565036ddd8e6949ee82eb63";
    hash = "sha256-4SVZD0aHKsn97B5bhCf7URR6iQhJlYGALKWhDg+lGhU=";
  };

  cargoHash = "sha256-OBWgNQ3OfqztaQwbK4fjOp7Lbu58U6j8tbStJ17bIko=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = with lib; {
    description = "X11 XTEST reimplementation primarily for Steam Controller on Wayland";
    homepage = "https://github.com/Supreeeme/extest";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "extest";
    platforms = platforms.linux;
  };
}
