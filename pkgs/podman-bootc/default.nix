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
  version = "0.1.1-unstable-2024-09-04";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "e3e65283cf58bb3896978f4afb9932a10d712043";
    hash = "sha256-+Opv+UmdC4IDT7RmYQSR+QrtNAPQPM/KyAmDZLeh2N4=";
  };

  vendorHash = "sha256-PkMQ/y/0c5drGU6d3OAdZPJuMqdb/XRfddFeHINtlZ4=";

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
