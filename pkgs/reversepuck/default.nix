{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "reversepuck";
  version = "0.9.39";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "safijari";
    repo = "openpuck";
    tag = finalAttrs.version;
    hash = "sha256-AE6p1mzRKWPxq1RTofF/pENRBpbUu/RuiAvC6ue38Xg=";
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

  meta = {
    description = "Steam Deck forwarder that emulates a wireless Steam Controller 2 via OpenPuck";
    homepage = "https://github.com/safijari/openpuck";
    license = lib.licenses.agpl3Only;
    mainProgram = "reversepuck";
    maintainers = with lib.maintainers; [ devusb ];
    platforms = lib.platforms.linux;
  };
})
