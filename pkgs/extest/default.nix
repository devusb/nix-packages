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
  version = "1.0.2-unstable-2024-11-06";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = "1a419a1691c6accaafef6cfc962a06712d4658e9";
    hash = "sha256-q0BqvdIdcUARGmaPOnzPVLtcWFHJeZ9t2jcfYxS0KTk=";
  };

  cargoHash = "sha256-PPy1uDZLG+ocVRos83gMvJvgi5qc12hUrcXcPXl+dhs=";

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
