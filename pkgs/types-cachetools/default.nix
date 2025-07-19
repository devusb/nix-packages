{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "types-cachetools";
  version = "6.1.0.20250717";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types_cachetools";
    hash = "sha256-SsyOJd6fX4TdF26oHc/6fLJDk4absuWeaS39ATmh5m8=";
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
