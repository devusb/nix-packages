{ pkgs, self }:
pkgs.testers.nixosTest {
  name = "heb-mcp";
  nodes.machine =
    { ... }:
    {
      imports = [
        self.nixosModules.overlay
        self.nixosModules.heb-mcp
      ];
      services.heb-mcp = {
        enable = true;
        settings = {
          MCP_SERVER_URL = "http://localhost:3000";
          HEB_SESSION_ENCRYPTION_KEY = "MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY=";
        };
      };
      environment.systemPackages = [ pkgs.curl ];
    };
  testScript = ''
    machine.wait_for_unit("heb-mcp.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl -sf http://localhost:3000/health | grep -q ok")
  '';
}
