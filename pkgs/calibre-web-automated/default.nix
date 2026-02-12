{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "calibre-web-automated";
  version = "4.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crocodilestick";
    repo = "Calibre-Web-Automated";
    tag = "v${version}";
    hash = "sha256-4BvExsiSv9hyeLjWuRxR+xGW7Fz2eUEJo5piRgE/ang=";
  };

  patches = [
    # default-logger.patch switches default logger to /dev/stdout. Otherwise calibre-web tries to open a file relative
    # to its location, which can't be done as the store is read-only. Log file location can later be configured using UI
    # if needed.
    ./default-logger.patch
    # DB migrations adds an env var __RUN_MIGRATIONS_AND_EXIT that, when set, instructs calibre-web to run DB migrations
    # and exit. This is gonna be used to configure calibre-web declaratively, as most of its configuration parameters
    # are stored in the DB.
    ./db-migrations.patch
  ];

  # calibre-web-automated doesn't follow setuptools directory structure.
  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb

    substituteInPlace pyproject.toml \
      --replace-fail 'cps = "calibreweb:main"' 'calibre-web = "calibreweb:main"'

    # Fix hardcoded Docker paths — every reference shares the same prefix
    substituteInPlace \
      src/calibreweb/cps/admin.py \
      src/calibreweb/cps/cwa_functions.py \
      src/calibreweb/cps/cw_login/utils.py \
      src/calibreweb/cps/duplicates.py \
      src/calibreweb/cps/editbooks.py \
      src/calibreweb/cps/helper.py \
      src/calibreweb/cps/metadata_helper.py \
      src/calibreweb/cps/progress_syncing/settings.py \
      src/calibreweb/cps/render_template.py \
      src/calibreweb/cps/schedule.py \
      src/calibreweb/cps/search_metadata.py \
      src/calibreweb/cps/tasks/duplicate_scan.py \
      src/calibreweb/cps/web.py \
      --replace-fail '/app/calibre-web-automated' "$out/share/calibre-web-automated"

    # Bake version info so it shows up in the admin UI
    substituteInPlace src/calibreweb/cps/constants.py \
      --replace-fail '"/app/CWA_RELEASE"' '"${placeholder "out"}/share/calibre-web-automated/CWA_RELEASE"' \
      --replace-fail '"/app/CWA_STABLE_RELEASE"' '"${placeholder "out"}/share/calibre-web-automated/CWA_RELEASE"'
    substituteInPlace src/calibreweb/cps/admin.py \
      --replace-fail '"/app/CWA_RELEASE"' '"${placeholder "out"}/share/calibre-web-automated/CWA_RELEASE"'

    # Fix hardcoded /app/ paths for runtime writable files — point them at
    # /config/ which the NixOS module bind-mounts to the state directory.
    substituteInPlace src/calibreweb/cps/render_template.py \
      --replace-fail "'/app/cwa_update_notice'" "'/config/cwa_update_notice'" \
      --replace-fail "'/app/theme_migration_notice'" "'/config/theme_migration_notice'"
  '';

  postInstall = ''
    mkdir -p $out/share/calibre-web-automated
    cp -r scripts $out/share/calibre-web-automated/scripts
    cp $src/dirs.json $out/share/calibre-web-automated/dirs.json
    echo "v${version}" > $out/share/calibre-web-automated/CWA_RELEASE

    # The upstream project runs from source in Docker — setuptools doesn't
    # include non-Python data files without git metadata. Copy templates,
    # static assets, and translations into the installed package tree where
    # constants.py expects them (BASE_DIR/cps/{templates,static,translations}).
    siteDir=$out/lib/${python3Packages.python.libPrefix}/site-packages/calibreweb
    cp -r src/calibreweb/cps/templates $siteDir/cps/templates
    cp -r src/calibreweb/cps/static $siteDir/cps/static
    cp -r src/calibreweb/cps/translations $siteDir/cps/translations

    # Note: CONFIG_DIR in constants.py defaults to BASE_DIR (read-only in Nix).
    # The NixOS module uses BindPaths to mount the state directory at /config and
    # sets CALIBRE_DBPATH=/config so CONFIG_DIR points somewhere writable at
    # runtime (for thumbnails, migrations, etc.).
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    apscheduler
    babel
    bleach
    chardet
    cryptography
    flask
    flask-babel
    flask-httpauth
    flask-limiter
    flask-principal
    flask-wtf
    iso-639
    lxml
    netifaces-plus
    pycountry
    pypdf
    python-magic
    pytz
    regex
    polib
    qrcode
    requests
    sqlalchemy
    tabulate
    tornado
    unidecode
    urllib3
    wand
  ];

  optional-dependencies = {
    comics = with python3Packages; [
      comicapi
      natsort
    ];

    gdrive = with python3Packages; [
      gevent
      google-api-python-client
      greenlet
      httplib2
      oauth2client
      pyasn1-modules
      # https://github.com/NixOS/nixpkgs/commit/bf28e24140352e2e8cb952097febff0e94ea6a1e
      # pydrive2
      pyyaml
      rsa
      uritemplate
    ];

    gmail = with python3Packages; [
      google-api-python-client
      google-auth-oauthlib
    ];

    # We don't support the goodreads feature, as the `goodreads` package is
    # archived and depends on other long unmaintained packages (rauth & nose)
    # goodreads = [ ];

    kobo = with python3Packages; [ jsonschema ];

    ldap = with python3Packages; [
      flask-simpleldap
      python-ldap
    ];

    metadata = with python3Packages; [
      faust-cchardet
      html2text
      markdown2
      mutagen
      py7zr
      pycountry
      python-dateutil
      rarfile
      scholarly
    ];

    oauth = with python3Packages; [
      flask-dance
      sqlalchemy-utils
    ];
  };

  pythonRelaxDeps = [
    "apscheduler"
    "bleach"
    "cryptography"
    "flask"
    "flask-limiter"
    "lxml"
    "pypdf"
    "regex"
    "tornado"
    "unidecode"
  ];

  nativeCheckInputs = lib.concatAttrValues optional-dependencies;

  # rapidfuzz (transitive dep via scholarly) fails to build on Darwin:
  # its CMake atomic check hardcodes -std=c++11 on Apple which is
  # incompatible with the C++20 requirement from taskflow 3.11.
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "calibreweb" ];

  meta = {
    description = "Calibre-Web but automated and with many new features";
    homepage = "https://github.com/crocodilestick/Calibre-Web-Automated";
    changelog = "https://github.com/crocodilestick/Calibre-Web-Automated/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "calibre-web";
    platforms = lib.platforms.all;
  };
}
