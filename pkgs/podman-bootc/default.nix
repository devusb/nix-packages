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
  version = "unstable-2024-05-23";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "78596d8a84e90afd90981ae02db2640cca08934b";
    hash = "sha256-wbKJW0XOIOzUdCKX8PgXCpbFcr1SNMRe0X63MJ/Dadk=";
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
