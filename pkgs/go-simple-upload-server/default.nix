{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-cVnmTJwBQ0I2y578Q3yd9u8KxDKoFjTbdXJJLU6Y+pw=";
  };

  vendorHash = "sha256-NRLKNZGia4n/BYzBPVqyn7iweX6zZYarOvIjO1rRqfw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple HTTP server to save artifacts";
    homepage = "https://github.com/mayth/go-simple-upload-server";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "go-simple-upload-server";
  };
}
