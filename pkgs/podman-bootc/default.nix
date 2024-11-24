{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, btrfs-progs
, libvirt
, gpgme
, xorriso
, lvm2
}:

buildGoModule {
  pname = "podman-bootc";
  version = "0.1.1-unstable-2024-11-13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "4bab85f45bb85717a9ffd78d4da6515b27e34e23";
    hash = "sha256-3Pa+GJt5Kp3osc47DSwG6WTbYJ2uqGxtRjZ1DCLq4Ms=";
  };

  vendorHash = "sha256-8QP4NziLwEo0M4NW5UgSEMAVgBDxmnE+PLbpyclK9RQ=";

  ldflags = [ "-s" "-w" ];

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
