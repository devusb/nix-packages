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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-4bB1EKK9XUkX8o3ca2dQtJe0UuSDgITVXWnpddTsJDs=";
  };

  nativeBuildInputs = [ cmake qtbase kcmutils extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin libepoxy libxcb ];

  meta = with lib; {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
  };
}
