{
  stdenv,
  lib,
  fetchurl,
  kernel,
  ...
}:

stdenv.mkDerivation rec {
  name = "igb-${version}-${kernel.version}";
  version = "5.15.7";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/812536/igb-${version}.tar.gz";
    hash = "sha256-A5Vk1EC38YUopzjG9BqdUWZmdSs9mu77L9sAAUV8lYU=";
  };

  sourceRoot = "igb-${version}/src";

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  CONFFILE = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/.config";

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  preBuild = ''
    makeFlags="$makeFlags -C ${KSRC} M=$(pwd)"
    cp ${./kcompat_generated_defs.h} ./kcompat_generated_defs.h
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Intel® Network Adapter Driver for 82575/6, 82580, I350, and I210/211-based Gigabit Network Connections";
    homepage = "https://www.intel.com/content/www/us/en/download/14098/intel-network-adapter-driver-for-82575-6-82580-i350-and-i210-211-based-gigabit-network-connections-for-linux.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.devusb ];
    platforms = platforms.linux;
  };
}
