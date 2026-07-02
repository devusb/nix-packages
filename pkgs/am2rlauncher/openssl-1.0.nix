{
  lib,
  stdenv,
  fetchurl,
  perl,
}:
stdenv.mkDerivation rec {
  pname = "openssl";
  version = "1.0.2u";

  src = fetchurl {
    url = "https://www.openssl.org/source/old/1.0.2/openssl-${version}.tar.gz";
    sha256 = "ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16";
  };

  nativeBuildInputs = [ perl ];

  configurePhase = ''
    runHook preConfigure
    ./Configure linux-elf shared no-asm --prefix=$out --openssldir=$out/etc/ssl
    runHook postConfigure
  '';

  enableParallelBuilding = false;

  installTargets = [ "install_sw" ];

  meta = {
    homepage = "https://www.openssl.org/";
    description = "OpenSSL 1.0.2 built 32-bit for the AM2R GameMaker runner";
    license = lib.licenses.openssl;
    platforms = [ "i686-linux" ];
  };
}
