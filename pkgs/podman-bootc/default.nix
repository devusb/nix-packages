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
  version = "0.1.2-unstable-2025-08-05";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "829cfb4e8891b17ebc003ec71e2ccd837ee271a4";
    hash = "sha256-JIHJox8+Sn3g6anYrbpYoHL2JCUG+hhUYaRK9rODV8s=";
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
