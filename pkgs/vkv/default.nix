{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-/vKEiRPykZX0C2G4OhkSq4O8p04JW98N+hbcdwy+VaA=";
  };

  vendorHash = "sha256-WYRLVC65d2QKzxz1o9Z8YOay/8lod5tjvcZ1zfNUKDY=";

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
