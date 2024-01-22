{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "node-red";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "node-red";
    repo = "node-red";
    rev = version;
    hash = "sha256-tIgmq4pMbO/AgmhFmVIEnLCt1rHM1b4cCwQTAdYaA2k=";
  };

  forceGitDeps = true;
  makeCacheWritable = true;

  npmDepsHash = "sha256-NLXxxTALxTLAw4SM5Pa69gp2NZoVrCzxCmLi8i7JY8E=";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/node-red/packages/node_modules/node-red/red.js $out/bin/node-red
  '';

  meta = with lib; {
    description = "Low-code programming for event-driven applications";
    homepage = "https://github.com/node-red/node-red";
    changelog = "https://github.com/node-red/node-red/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "node-red";
    platforms = platforms.all;
  };
}
