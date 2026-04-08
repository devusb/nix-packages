{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  linux-pam,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "littlesnitch";
  version = "1.0.0";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-dypTOHhsa/zNpponXkIG3+9yqgvCrLSiNcwjInR6Vu8=";
        aarch64-linux = "sha256-Vmx7YynwIralDYsUzS/C4uy1aUPo4nPaX9r4nLB57iA=";
      };
    in
    fetchurl {
      url = "https://obdev.at/downloads/littlesnitch-linux/littlesnitch_${version}_${suffix}.deb";
      inherit hash;
    };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    linux-pam
    sqlite
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 usr/bin/littlesnitch $out/bin/littlesnitch
    install -Dm644 usr/lib/systemd/system/littlesnitch.service $out/lib/systemd/system/littlesnitch.service
    install -Dm644 usr/share/metainfo/at.obdev.littlesnitch.metainfo.xml $out/share/metainfo/at.obdev.littlesnitch.metainfo.xml
    substituteInPlace $out/lib/systemd/system/littlesnitch.service \
      --replace-fail "/usr/bin/littlesnitch" "$out/bin/littlesnitch"
    runHook postInstall
  '';

  meta = {
    description = "Network monitor that lets you control which applications connect to the internet";
    homepage = "https://obdev.at/products/littlesnitch-linux/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "littlesnitch";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
