{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-HPkEvHdoBYOYHJvRaTiHb+kyfBxEIW2+h3iLlZOpW+w=";
  };

  vendorHash = "sha256-Ttcc3Jq/fQhR3EstgyyCXlqB6hl9u/U9gjk7gd8OKDQ=";

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
