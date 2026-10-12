#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq libxml2 gnugrep gnused
set -euo pipefail

nixfile=pkgs/dreamm/default.nix

latest=$(curl -fsSL https://dreamm.aarongiles.com/version.xml \
  | xmllint --xpath 'string(//*[local-name()="entry"][1]/*[local-name()="title"])' -)
version=${latest#DREAMM }
current=$(grep -oP 'version = "\K[^"]+' "$nixfile")

if [ "$version" = "$current" ]; then
  echo "dreamm is up to date at $current"
  exit 0
fi

prefetch() {
  nix store prefetch-file --json --unpack \
    "https://dreamm.aarongiles.com/releases/dreamm-$version-$1.tgz" | jq -r .hash
}
x64_hash=$(prefetch linux-x64)
arm64_hash=$(prefetch linux-arm64)

sed -i \
  -e "s|version = \"$current\";|version = \"$version\";|" \
  -e "s|x86_64-linux = \"sha256-[^\"]*\";|x86_64-linux = \"$x64_hash\";|" \
  -e "s|aarch64-linux = \"sha256-[^\"]*\";|aarch64-linux = \"$arm64_hash\";|" \
  "$nixfile"
