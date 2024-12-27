{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-simple-upload-server";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mayth";
    repo = "go-simple-upload-server";
    rev = "v${version}";
    hash = "sha256-fQyQD3yAWVH5oIMIQO2yxduo/7bD0+WQkygjAjNbTgs=";
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
