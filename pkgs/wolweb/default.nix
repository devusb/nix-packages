{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "wolweb";
  version = "1-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "sameerdhoot";
    repo = "wolweb";
    rev = "13cdb99a84159db775b23ed43eac1d5901681044";
    hash = "sha256-xSG65qh+gr2WenRZShsgV/VkpO00c2VkrZHP5IgHesI=";
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
