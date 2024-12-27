{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-9V+zx/bgy/7I78c5wTSueB8WUMEUqxA2vlCOYxt1wLk=";
  };

  vendorHash = "sha256-qD43abdtzoYVbWrakQmFKspnYCm1zL7DJeRpI48N7uk=";

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
