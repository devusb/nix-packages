{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "extest";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = "2a0a1f27239f6307b333a68ca7023ccf90215f3e";
    hash = "sha256-ZCHOyAACYoV3wW7en374Kfj0STmi0+72INKGNQkO/rU=";
  };

  cargoHash = "sha256-fTgwUn5ndIO8xsyTA8WzCX37FhOl4w3U0FCSRDeY2iA=";

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
    maintainers = with maintainers; [ ];
    mainProgram = "extest";
  };
}
