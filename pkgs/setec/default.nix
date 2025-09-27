{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "setec";
  version = "0-unstable-2025-09-16";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "setec";
    rev = "71d9e0b5aae22a7b674e5af94c8594aa1fc7a8d4";
    hash = "sha256-XsZxaWsNQzwLlTeo9e+k/6FbLrxof1JEICrXSyXu2mk=";
  };

  vendorHash = "sha256-J0hcYnQIDwGx7wKwmZBqY/WmwQwpSF9Dj+9dzzvCDZ8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A secrets management service that uses Tailscale for access control";
    homepage = "https://github.com/tailscale/setec";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "setec";
  };
}
