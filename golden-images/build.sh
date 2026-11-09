#!/usr/bin/env bash
# Build one golden VM disk: pinned Ubuntu 24.04 cloud image + the demo HTTP
# endpoint baked in with a version string. Output: web-<version>.qcow2.
# Runs in CI (needs libguestfs-tools); see .github/workflows/golden-images.yaml.
set -euo pipefail
VERSION="${1:?usage: build.sh <v1|v2>}"
BASE_URL="https://cloud-images.ubuntu.com/noble/20260926/noble-server-cloudimg-amd64.img"
BASE_SHA256="6a81c37564db9b1ee84e141922625e1d7c5b389b99bb3c572e0243607d5bb4d2"
here="$(cd "$(dirname "$0")" && pwd)"

[ -f base.img ] || curl -fsSL -o base.img "$BASE_URL"
echo "${BASE_SHA256}  base.img" | sha256sum -c -

out="web-${VERSION}.qcow2"
cp base.img "$out"
printf '%s\n' "$VERSION" > version
virt-customize -a "$out" \
  --mkdir /etc/fluxcon \
  --upload version:/etc/fluxcon/version \
  --upload "$here/fluxcon-web.py:/usr/local/bin/fluxcon-web" \
  --chmod 0755:/usr/local/bin/fluxcon-web \
  --upload "$here/fluxcon-web.service:/etc/systemd/system/fluxcon-web.service" \
  --run-command 'systemctl enable fluxcon-web.service' \
  --write "/etc/motd:FluxCon demo golden image web-${VERSION}\n" \
  --truncate /etc/machine-id
echo "built $out"
