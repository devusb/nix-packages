{
  lib,
  fetchFromGitHub,
  perlPackages,
}:

perlPackages.buildPerlPackage rec {
  pname = "xmltv";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "XMLTV";
    repo = "xmltv";
    rev = "v${version}";
    hash = "sha256-edfg18E8BSBZy5OVL0T5F/SmNiSlbHZeQH/a9XCSDnE=";
  };

  buildInputs = with perlPackages; [
    CGI
    CompressZlib
    DataDump
    DateManip
    DateTime
    DateTimeFormatISO8601
    DateTimeFormatSQLite
    DateTimeTimeZone
    DBI
    DBDSQLite
    DigestSHA
    FileHomeDir
    FileSlurp
    FileWhich
    HTMLParser
    HTMLTree
    HTTPCookies
    IOStringy
    JSON
    ListMoreUtils
    LWP
    LWPProtocolHttps
    LWPUserAgent
    LWPUserAgentDetermined
    SOAPLite
    TermReadKey
    TextUnidecode
    TimeDate
    TimePiece
    Tk
    URI
    XMLDOM
    XMLLibXML
    XMLLibXSLT
    XMLParser
    XMLTreePP
    XMLTwig
    XMLWriter
  ];

  postInstall = ''
    install -Dm 755 grab/zz_sdjson/tv_grab_zz_sdjson $out/bin/tv_grab_zz_sdjson
  '';

  doCheck = false;

  meta = {
    description = "Utilities to obtain, generate, and post-process TV listings data in XMLTV format";
    homepage = "https://github.com/XMLTV/xmltv";
    changelog = "https://github.com/XMLTV/xmltv/blob/${src.rev}/Changes";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "xmltv";
    platforms = lib.platforms.all;
  };
}
