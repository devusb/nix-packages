{
  lib,
  stdenv,
  requireFile,
  unzip,
  autoPatchelfHook,
  alsa-lib,
  SDL2,
  gtk3,
  zlib,
  dbus,
  hidapi,
  libGL,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  udev,
  vulkan-loader,
  mono,
}:

stdenv.mkDerivation {
  pname = "xwvm";
  version = "20250531";

  src = requireFile {
    name = "XWVM_alpha_20250531_linux.zip";
    hash = "sha256-2F/SsaVwAvI69fqt/uwcjg/svXpugtNUJAjr2k6TC8c=";
    url = "https://www.moddb.com/mods/xwvm/downloads/xwvm-core-alpha-20250531-linux";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    alsa-lib
    SDL2

    alsa-lib
    gtk3
    (lib.getLib stdenv.cc.cc)
    zlib

    # Run-time libraries (loaded with dlopen)
    dbus
    hidapi
    libGL
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    mono
  ];

  installPhase = ''
    runHook preInstall
    install -D ../xwvm.x86_64 $out/bin/xwvm
    install -D ../libdecor-0.so.0 $out/libexec/xwvm/libdecor-0.so.0
    install -D ../libdecor-cairo.so $out/libexec/xwvm/libdecor-cairo.so
    install -D ../UnityPlayer.so $out/libexec/xwvm/UnityPlayer.so
    cp -r ../xwvm_Data $out/bin/xwvm_Data
    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libhidapi-hidraw.so.0 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/xwvm/UnityPlayer.so"

    patchelf \
    --add-needed libMonoSupportW.so \
    --add-needed libmonoboehm-2.0.so.1 \
    "$out/bin/xwvm_Data/MonoBleedingEdge/x86_64/libmonobdwgc-2.0.so"
  '';

  meta = {
    description = "A facilitator app to play Star Wars X-Wing from Lucas Arts and Totally Games";
    homepage = "https://www.moddb.com/mods/xwvm";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = with lib.licenses; [
    ];
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "xwvm";
    platforms = lib.platforms.linux;
  };
}
