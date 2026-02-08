{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jellystat";
  version = "V1.1.8";

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    rev = version;
    hash = "sha256-3wD9xy+P/edVJnLgImRyDCQ1xgVvkjN07T5JZDoJFY0=";
  };

  npmDepsHash = "sha256-Y40ZnpHjEbYOjDrgwjLxCTyGWHGH6Zw8JADUiJc4hl4=";

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
}
