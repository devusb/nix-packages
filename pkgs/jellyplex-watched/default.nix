{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "jellyplex-watched";
  version = "6.0.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "luigi311";
    repo = "JellyPlex-Watched";
    rev = "v${version}";
    hash = "sha256-Gs12QY8e+gSd6vE2GCHrEirTMz6f6MSIGmPhsUiYR3Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    plexapi
    requests
    python-dotenv
    aiohttp
  ];

  installPhase = ''
    runHook preInstall

    # add shebang so it can be patched
    sed -i -e '1i#!/usr/bin/python' main.py

    mkdir -p $out/bin
    mkdir -p $out/share/jellyplex-watched

    cp -r src $out/share/jellyplex-watched
    install -m 755 -t $out/share/jellyplex-watched main.py
    makeWrapper $out/share/jellyplex-watched/main.py $out/bin/jellyplex-watched \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sync watched between jellyfin and plex locally";
    homepage = "https://github.com/luigi311/JellyPlex-Watched";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "jellyplex-watched";
    platforms = platforms.all;
  };
}
