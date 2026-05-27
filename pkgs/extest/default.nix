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
  version = "1.0.3-unstable-2026-05-25";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = "cb77cd4f80f83393a24bae17dd975e14fa6eb1b2";
    hash = "sha256-afonaHQCTtOJOAFRsiarFkFVI+FurVva9AUVSWmRqY4=";
  };

  cargoHash = "sha256-IKpxj71AP5bkP2RWmfVUZOW8/9ESv5+LkwiFhUura6g=";

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
