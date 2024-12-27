{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-cePCReQZ0Z0vyMeQOQVDAgPLC/OOkMdRp1iQpxSi0Ms=";
  };

  npmDepsHash = "sha256-oQ7HVrE0CsATf9ADr+IlnE3TNNU5JKZB3vd2otaL1iw=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
