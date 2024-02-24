{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs
}:
let
  quakejs-docker = fetchFromGitHub {
    owner = "treyyoder";
    repo = "quakejs-docker";
    rev = "6cbe1c4a0024505dc4f00f524b9ecbecd0d2d0c0";
    hash = "sha256-62CaI9+ivOTm8rjGl5t1ZcFRTA6ZIXLqm3pImMS7mNU=";
  };
in
buildNpmPackage {
  name = "quakejs";

  src = fetchFromGitHub {
    owner = "begleysm";
    repo = "quakejs";
    rev = "adfcf15450ba20cc70353914ef76642f91208966";
    hash = "sha256-FnTzAVqAclInEXVbS7PlUCNCoD+zvAGtxXJcbYNALmI=";
  };

  npmDepsHash = "sha256-/y/xeT0tMV0M/3vJbZw0xxdm5kIAzSg93Kx4M2G1mJo=";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
    cp ${quakejs-docker}/include/ioq3ded/ioq3ded.fixed.js ./build/ioq3ded.js
  '';

  dontNpmBuild = true;

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/quakejs --add-flags "$out/lib/node_modules/quakejs/bin/web.js" 
    makeWrapper ${lib.getExe nodejs} $out/bin/ioq3ded --add-flags "$out/lib/node_modules/quakejs/build/ioq3ded.js"
  '';

  meta = with lib; {
    description = "QuakeJS is a port of ioquake3 to JavaScript with the help of Emscripten";
    homepage = "https://github.com/begleysm/quakejs";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "quakejs";
    platforms = platforms.linux;
  };
}
