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
  version = "0.1.2-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "e12065917c53ea16c4aac22e83d79ee5d490af86";
    hash = "sha256-iN2j32+acFDise3R5sb7OBtw76LQc1EfW9mFXa9Ol3c=";
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
