{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, qtbase
, kwin
, kcmutils
, libepoxy
, libxcb
, lib
}:

stdenv.mkDerivation rec {
  pname = "kde-rounded-corners";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-8QkuIuHC0/fMxh8K3/I8GNhNPX+tw7kUMiU2oK12c0U=";
  };

  nativeBuildInputs = [ cmake qtbase kcmutils extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin libepoxy libxcb ];

  meta = with lib; {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flexagoon ];
  };
}
