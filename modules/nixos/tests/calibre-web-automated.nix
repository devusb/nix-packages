{ pkgs, self }:
let
  port = 8083;
in
pkgs.testers.nixosTest {
  name = "calibre-web-automated";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.overlay
        self.nixosModules.calibre-web-automated
      ];

      services.calibre-web-automated = {
        enable = true;
        listen.port = port;
        options = {
          calibreLibrary = "/tmp/books";
          reverseProxyAuth = {
            enable = true;
            header = "X-User";
          };
        };
      };

      environment.systemPackages = [ pkgs.calibre ];
    };

  testScript = ''
    start_all()

    machine.succeed(
        "mkdir /tmp/books && calibredb --library-path /tmp/books add -e --title test-book"
    )
    machine.succeed("systemctl restart calibre-web-automated")
    machine.wait_for_unit("calibre-web-automated.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed(
        "curl --fail -H X-User:admin 'http://localhost:${toString port}' | grep test-book"
    )
  '';
}
