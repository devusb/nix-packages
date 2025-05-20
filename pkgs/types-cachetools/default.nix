{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "types-cachetools";
  version = "5.5.0.20240820";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uIirXBpIEW93mc1QBLGEdM2CtUY6y1/7LbL8nHsFO8A=";
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
