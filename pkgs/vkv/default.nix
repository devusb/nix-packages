{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-2GsiaUYaL3t+WYH1XgkFxcG60uq4nxyHFX2VYAcUCps=";
  };

  vendorHash = "sha256-HUFoT2AjIu30l6XiEAXniX6yT+6rGVAcZPkVfiZ43Sw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  checkFlags = [
    # requires docker
    "-skip=TestVaultSuite"
  ];

  meta = with lib; {
    description = "vkv enables you to list, compare, import, document, backup & encrypt secrets from a HashiCorp Vault KV-v2 engine";
    homepage = "https://github.com/FalcoSuessgott/vkv";
    license = licenses.mit;
    mainProgram = "vkv";
  };
}
