{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "f8d7a936837c8bdb8e1af9fd99158f9b5551dbad";
    hash = "sha256-MUfggP95oT8c+x6ZKVADXLHucj/p0qKiVbH9oERTzgw=";
  };

  vendorHash = "sha256-OWW4+k/+tpAn5N4w0/5peEpGwbIHVyXp2m857JVKuFs=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "A secrets management service that uses Tailscale for access control";
    homepage = "https://github.com/tailscale/setec";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "setec";
  };
}
