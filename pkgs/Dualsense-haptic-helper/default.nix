{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dual-sense-haptic-helper";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "HotspringDev";
    repo = "DualSense-haptic-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m0xalmOpmcmxjhFxX7PHUYXC8kKjuFOjRg/6IhxVWgM=";
  };

  buildInputs = [
    alsa-lib
  ];

  preBuild = ''
    make clean
  '';

  buildPhase = ''
    runHook preBuild

    make ds_verbose_test

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ds_verbose_test $out/bin/ds_verbose_test

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Haptic helper for Linux Platform";
    homepage = "https://github.com/HotspringDev/DualSense-haptic-helper";
    changelog = "https://github.com/HotspringDev/DualSense-haptic-helper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "dual-sense-haptic-helper";
    platforms = lib.platforms.all;
  };
})
