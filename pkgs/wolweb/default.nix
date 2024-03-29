{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "wolweb";
  version = "unstable-2023-08-07";

  src = fetchFromGitHub {
    owner = "sameerdhoot";
    repo = "wolweb";
    rev = "496b4493176199603c46c50bcb3e1606e5b8f3d5";
    hash = "sha256-6QasD6c4XUr2zjPdzMGgsXCji8pv9KkYXZfs8yPpepA=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/sameerdhoot/wolweb/pull/36.patch";
      hash = "sha256-xd1OCCO8PqHT032GIzfkgc5a54SrY77rIOTB9d0Mnlk=";
    })
  ];

  vendorHash = "sha256-bUUZ/R0hPRYVqtrw8yUlVbxpnKoEGEb85saAn+9MFbo=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Web interface for sending Wake-on-lan (magic packet). An HTTP server built using GoLang and uses Bootstrap for UI";
    homepage = "https://github.com/sameerdhoot/wolweb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "wolweb";
  };
}
