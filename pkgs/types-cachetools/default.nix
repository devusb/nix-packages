{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "types-cachetools";
  version = "6.0.0.20250525";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types_cachetools";
    hash = "sha256-uvBvI0ysOutEwHiTRHugPs22wHQromB+KKNdOOaCGwI=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "cachetools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for cachetools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ devusb ];
  };
}
