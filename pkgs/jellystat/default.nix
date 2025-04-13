{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-sy/kt/p9pSSzB9u2aWtPwuH7RQQZkcuxZ3Hqw1PvN2E=";
  };

  npmDepsHash = "sha256-L/Ew5xx0ruVgmsv0+7NusyFwqFz94EyJlUhIZzawQOQ=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
