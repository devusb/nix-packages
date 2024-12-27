{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  btrfs-progs,
  libvirt,
  gpgme,
  xorriso,
  lvm2,
}:

buildGoModule {
  pname = "podman-bootc";
  version = "0.1.2-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "96bfc8f6803516d3cf17884935a5be1d81aa6ffe";
    hash = "sha256-Hxg2QSedPAWYZpuesUEFol9bpTppjB0/MpCcB+txMDc=";
  };

  vendorHash = "sha256-8QP4NziLwEo0M4NW5UgSEMAVgBDxmnE+PLbpyclK9RQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    btrfs-progs
    libvirt
    gpgme
    xorriso
    lvm2
  ];

  doCheck = false;

  meta = with lib; {
    description = "A scriptable CLI that offers an efficient and ergonomic \"edit-compile-debug\" cycle for bootable containers";
    homepage = "https://github.com/containers/podman-bootc";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "podman-bootc";
  };
}
