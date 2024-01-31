{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-bgw4lC5GjyKCfvZTPnx240SYvLqVcCarLxrV8XwjL+0=";
  };

  npmDepsHash = "sha256-qhESVfeTr0gkcnT8QCp+fv4B87hTCHlZOGz8dh+pMfA=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
