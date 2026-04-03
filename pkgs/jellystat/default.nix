{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-M7Gw/TgDB+vA5wtYf5vLxLZ5r9D8B9pVEBE0FiRGlKs=";
  };

  npmDepsHash = "sha256-Y40ZnpHjEbYOjDrgwjLxCTyGWHGH6Zw8JADUiJc4hl4=";

  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
