#!/usr/bin/env bash
set -euo pipefail

VERSION="${LAZYGIT_VERSION:-0.58.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS
case "$(uname -s)" in
    Linux)  OS="Linux";;
    Darwin) OS="Darwin";;
    *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1;;
esac

# Detect architecture
case "$(uname -m)" in
    x86_64)  ARCH="x86_64";;
    aarch64) ARCH="arm64";;
    arm64)   ARCH="arm64";;
    *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
esac

URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_${OS}_${ARCH}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading lazygit ${VERSION} for ${OS}/${ARCH}..."
curl -fsSL "${URL}" -o "${TMPDIR}/lazygit.tar.gz"
tar -xzf "${TMPDIR}/lazygit.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/lazygit" "${BIN_DIR}/lazygit"
chmod +x "${BIN_DIR}/lazygit"

echo "lazygit installed to ${BIN_DIR}/lazygit"
"${BIN_DIR}/lazygit" --version
