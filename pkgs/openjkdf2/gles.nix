{
  lib,
  openjkdf2,
  fetchpatch,
}:
openjkdf2.overrideAttrs (old: {
  pname = "openjkdf2-gles";

  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url = "https://github.com/devusb/OpenJKDF2/commit/21fa1b7d1175033dd0ef0072ff604799fb1017b2.patch";
      hash = "sha256-9EQFUyXDy/UKBCG1l81YTKGEow2QSIK1kS7eVkyhl8w=";
    })
  ];

  # The patched cmake natively consumes system libs (TARGET_USE_SYSTEM_LIBS=TRUE
  # is set in plat_linux_64_gles.cmake), so the upstream derivation's shim
  # postPatch is unnecessary — and wrong, because it targets cmake fragments
  # the GLES plat doesn't go through.
  postPatch = "";

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "PLAT_LINUX_64_GLES" true)
    (lib.cmakeBool "TARGET_NO_MULTIPLAYER_MENUS" true)
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 openjkdf2-gles $out/bin/openjkdf2-gles
    runHook postInstall
  '';

  meta = old.meta // {
    description = "${old.meta.description} (GLES3 build for Panfrost/V3D)";
    mainProgram = "openjkdf2-gles";
  };
})
