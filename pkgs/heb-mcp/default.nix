{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchPnpmDeps,
  makeWrapper,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "heb-mcp";
  version = "0.1.0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "iHildy";
    repo = "heb-sdk-unofficial";
    rev = "02e234cb8c71383f4c132e7864c892b071903fb5";
    hash = "sha256-tdDBvRXsk6VUMXxOFAhoYzGZw8xS/cm5byjDzZ1t0Gc=";
  };

  patches = [
    (fetchpatch {
      name = "proxy-header-auth.patch";
      url = "https://github.com/devusb/heb-sdk-unofficial/commit/e2be838ad5b7b4a2f8a9ff8b8e12092611803e15.patch";
      hash = "sha256-hrilxl/RayyvVnKa+1Y0ak6uqPmYqyo+C5684QG+1BM=";
    })
    (fetchpatch {
      name = "connect-without-clerk.patch";
      url = "https://github.com/devusb/heb-sdk-unofficial/commit/a50c822103526b16e5b86187c2593606e745a0e5.patch";
      hash = "sha256-WvxBvSuUmLl9FUk0RGk4wkafNT9YWlDgep6e+J4nhZE=";
    })
    (fetchpatch {
      name = "mcp-endpoint-methods.patch";
      url = "https://github.com/devusb/heb-sdk-unofficial/commit/c47daf2c29ccece6579b7ecc9520a5f4bab20f83.patch";
      hash = "sha256-6RU6/4/KwZ63u5d2bWZJaNFybJMyd+tG7+4RPs/hJaY=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  pnpmWorkspaces = [
    "heb-mcp-unofficial..."
    "web"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-fsN/8nynsMYwA25QZqlxq1W+JTe6cnFx7aoLvfKkfj0=";
  };

  postPatch = ''
    for pkg in heb-auth heb-sdk; do
      cat > packages/$pkg/tsconfig.build.json <<'JSON'
    {
      "extends": "./tsconfig.json",
      "compilerOptions": {
        "composite": false,
        "declarationMap": false
      }
    }
    JSON
    done
  '';

  buildPhase = ''
    runHook preBuild

    pnpm --filter=heb-mcp-unofficial... run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm config set --location=project injectWorkspacePackages true
    pnpm deploy --ignore-script --filter=heb-mcp-unofficial --prod $out/lib/heb-mcp

    cp -R packages/heb-mcp/web/dist $out/lib/heb-mcp/web/

    makeWrapper ${lib.getExe nodejs} $out/bin/heb-mcp \
      --add-flags $out/lib/heb-mcp/dist/server.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "MCP server exposing unofficial H-E-B grocery API functionality as tools";
    homepage = "https://github.com/iHildy/heb-sdk-unofficial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "heb-mcp";
  };
})
