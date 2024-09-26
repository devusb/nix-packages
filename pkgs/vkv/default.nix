{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-YaUDPusuMr8pDsODtrYn2NPjNG0DclD6Pz7ZxcNLubU=";
  };

  vendorHash = "sha256-b5BCXTSeUSKj6QVHBBV5PS28+FZ0hAq8t2+X7XoNUUY=";

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
