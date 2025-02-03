{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-6MV2XoUwXeUV4kJIcN03KylVc6LwSJxtM60xn1ywT/U=";
  };

  npmDepsHash = "sha256-nsFGRRAKDk33jMceUHjTfNm2FutPpMHazmOgIyBToCQ=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
