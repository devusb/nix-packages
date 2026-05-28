{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "wolweb";
  version = "1-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "sameerdhoot";
    repo = "wolweb";
    rev = "f3745c89d399015b5ff359d7d10fb9e29ff7892e";
    hash = "sha256-eZ9ZloizhSleK6fH/ZZM5296vxIukdjSJdRbxm5IXRY=";
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
