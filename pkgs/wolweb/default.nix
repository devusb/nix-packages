{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "wolweb";
  version = "1-unstable-2026-09-17";

  src = fetchFromGitHub {
    owner = "sameerdhoot";
    repo = "wolweb";
    rev = "b66c4fb15f464d9f80fe286c004c53a3cad11807";
    hash = "sha256-HCMwdF3X3pG3TXAff6SrnFcjd2741BCOA8lPmI8GBQw=";
  };

  vendorHash = "sha256-bUUZ/R0hPRYVqtrw8yUlVbxpnKoEGEb85saAn+9MFbo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Web interface for sending Wake-on-lan (magic packet). An HTTP server built using GoLang and uses Bootstrap for UI";
    homepage = "https://github.com/sameerdhoot/wolweb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "wolweb";
  };
}
