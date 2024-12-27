{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "wolweb";
  version = "1-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "sameerdhoot";
    repo = "wolweb";
    rev = "b447d507c4cc7068116946c2981cafcf130cecfa";
    hash = "sha256-y9CzO4o+LZeAappk/KGX2vP2TtrT5Rp3OxI6ncCEXn0=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/sameerdhoot/wolweb/pull/36.patch";
      hash = "sha256-xd1OCCO8PqHT032GIzfkgc5a54SrY77rIOTB9d0Mnlk=";
    })
  ];

  vendorHash = "sha256-bUUZ/R0hPRYVqtrw8yUlVbxpnKoEGEb85saAn+9MFbo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Web interface for sending Wake-on-lan (magic packet). An HTTP server built using GoLang and uses Bootstrap for UI";
    homepage = "https://github.com/sameerdhoot/wolweb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "wolweb";
  };
}
