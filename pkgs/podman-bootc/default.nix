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
  version = "0.1.2-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "df3c05b7cdb748d2720de58faf53babf0de43242";
    hash = "sha256-TNN87GB/eOmIxeqBJjB78dBKBYJMlIXC1/UFuSiKv8E=";
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
