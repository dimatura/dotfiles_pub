#!/usr/bin/env bash
set -euo pipefail

VERSION="${MCAP_VERSION:-0.0.60}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS
case "$(uname -s)" in
    Linux)  OS="linux";;
    Darwin) OS="macos";;
    *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1;;
esac

# Detect architecture
case "$(uname -m)" in
    x86_64)  ARCH="amd64";;
    aarch64) ARCH="arm64";;
    arm64)   ARCH="arm64";;
    *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
esac

URL="https://github.com/foxglove/mcap/releases/download/releases/mcap-cli/v${VERSION}/mcap-${OS}-${ARCH}"

echo "Downloading mcap ${VERSION} for ${OS}/${ARCH}..."
mkdir -p "${BIN_DIR}"
curl -fsSL "${URL}" -o "${BIN_DIR}/mcap"
chmod +x "${BIN_DIR}/mcap"

echo "mcap installed to ${BIN_DIR}/mcap"
"${BIN_DIR}/mcap" version
