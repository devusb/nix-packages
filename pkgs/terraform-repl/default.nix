{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  hcl2json,
  terraform,
  jq,
}:

stdenvNoCC.mkDerivation rec {
  pname = "terraform-repl";
  version = "0-unstable-2024-11-30";

  src = fetchFromGitHub {
    owner = "paololazzari";
    repo = "terraform-repl";
    rev = "959fa153707172eec2792e6d508b1906ab961ac4";
    hash = "sha256-9Nkk08CHqyODFeB9EuDU+IWG9hv5e4ev6RANLiTVvG0=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  doBuild = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 terraform-repl $out/bin/terraform-repl
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/terraform-repl\
      --prefix PATH : ${
        lib.makeBinPath [
          hcl2json
          terraform
          jq
        ]
      }
  '';

  meta = {
    description = "A terraform console wrapper for a better REPL experience";
    homepage = "https://github.com/paololazzari/terraform-repl";
    changelog = "https://github.com/paololazzari/terraform-repl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "terraform-repl";
    platforms = lib.platforms.all;
  };
}
