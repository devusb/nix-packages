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
      environment.etc."heb-mcp.env".text =
        "HEB_SESSION_ENCRYPTION_KEY=bm90LWEtcmVhbC1rZXktZm9yLW5peG9zLXRlc3QtMAo=";
      services.heb-mcp = {
        enable = true;
        environmentFile = "/etc/heb-mcp.env";
        settings.MCP_SERVER_URL = "http://localhost:3000";
      };
      environment.systemPackages = [ pkgs.curl ];
    };
  testScript = ''
    machine.wait_for_unit("heb-mcp.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl -sf http://localhost:3000/health | grep -q ok")
    machine.succeed("ss -tln | grep -q '127.0.0.1:3000'")
    machine.fail("ss -tln | grep -q '0.0.0.0:3000'")
  '';
}
