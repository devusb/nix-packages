{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-RYZcczgWqrf6tzZmElttLIcz2Cb8MyXjyv7rpWPE0ZU=";
  };

  npmDepsHash = "sha256-W7Q0VRIAE0D0poBQKRiLxn/UP37QCzr9qLwRIJAjg78=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
