{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "reversepuck";
  version = "0.9.59";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "safijari";
    repo = "openpuck";
    tag = finalAttrs.version;
    hash = "sha256-JHf/lVpJjNNbfzYGMzXEKefyg4BEjVu5yWvyLh9OE/c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    pyserial
    pygame
    pyusb
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/reversepuck
    cp ReversePuck/*.py $out/share/reversepuck/

    makeWrapper ${python3.interpreter} $out/bin/reversepuck \
      --add-flags "$out/share/reversepuck/openctrl.py" \
      --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--flake" ];
  };

  meta = {
    description = "Steam Deck forwarder that emulates a wireless Steam Controller 2 via OpenPuck";
    homepage = "https://github.com/safijari/openpuck";
    license = lib.licenses.agpl3Only;
    mainProgram = "reversepuck";
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.linux;
  };
})
