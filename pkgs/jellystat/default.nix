{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-5fs+enXPFTjJWX4hEo2+Rvtt+008+Nf+bc91vCF85PQ=";
  };

  npmDepsHash = "sha256-jQrbFY2NFujhC5ioE2XpqR905g7NJowIfV+RsSIkH3g=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
