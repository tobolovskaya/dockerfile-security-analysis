#!/usr/bin/env bash
# Download the scanners from their GitHub releases and verify SHA-256 checksums.
set -euo pipefail

HADOLINT_VERSION=2.15.1
TRIVY_VERSION=0.76.2
DOCKLE_VERSION=0.4.15

mkdir -p bin

curl -sSfL -o bin/hadolint "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-linux-x86_64"
curl -sSfL -o trivy.tgz "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz"
curl -sSfL -o dockle.tgz "https://github.com/goodwithtech/dockle/releases/download/v${DOCKLE_VERSION}/dockle_${DOCKLE_VERSION}_Linux-64bit.tar.gz"

sha256sum -c - <<SUMS
c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507  bin/hadolint
bc0fc726e017b8927a62b2d3531d7a84ee01769daf5c99ed866dced54089fdbf  trivy.tgz
8bfc9183d1d3d67800edb45bea4bb63ddf1d28bec5f89944075a07007d79caad  dockle.tgz
SUMS

tar -xzf trivy.tgz -C bin trivy
tar -xzf dockle.tgz -C bin dockle
chmod +x bin/hadolint
rm trivy.tgz dockle.tgz
echo "$PWD/bin" >> "$GITHUB_PATH"
