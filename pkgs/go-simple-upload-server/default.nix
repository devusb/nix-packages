{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-EqvZappB5mmGnkG5lu+5gQiJlLC9l92B6G9lvAqDvqw=";
  };

  vendorHash = "sha256-NRLKNZGia4n/BYzBPVqyn7iweX6zZYarOvIjO1rRqfw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Simple HTTP server to save artifacts";
    homepage = "https://github.com/mayth/go-simple-upload-server";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "go-simple-upload-server";
  };
}
