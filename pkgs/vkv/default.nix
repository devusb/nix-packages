{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vkv";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "FalcoSuessgott";
    repo = "vkv";
    rev = "v${version}";
    hash = "sha256-03RUSVtaYQfCj9huO7nsTVGx70kQuggZG0nM1bzrjm0=";
  };

  vendorHash = "sha256-i++0I/1sLam1rkYi+bsB7LtpLrxZQFHbGjK5O0qvNiM=";

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
