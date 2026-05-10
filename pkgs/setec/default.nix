{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "802071d7d5bf47343e023f759846ac98ddf68fae";
    hash = "sha256-XjCdr7QhUk9gvfWLq7lXv/zaS4ANxs4tpwTU3lhqkj4=";
  };

  vendorHash = "sha256-7JaOvBCETiqXj33YSY5ESIhH3Kp+NSCAAVkre8Zg0RA=";

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
