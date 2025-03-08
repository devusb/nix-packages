{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  btrfs-progs,
  libvirt,
  gpgme,
  xorriso,
  lvm2,
}:

buildGoModule {
  pname = "podman-bootc";
  version = "0.1.2-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-bootc";
    rev = "0125ec1a059eae132b3a526f5910abe8a58df8eb";
    hash = "sha256-L8ucJpTvFoXhTLVNHRDqzGQ3DmB4oYvPNRSHXpLQdO0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/containers/podman-bootc/commit/77791214a39bec80675411c24793c34278ae6c48.patch";
      hash = "sha256-KMOAHfcjwShExkKoOGr4XHMRJQyF78qygeBiHrCn1Zc=";
      revert = true;
    })
  ];

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
