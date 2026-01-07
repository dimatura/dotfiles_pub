#!/usr/bin/env bash
set -euo pipefail

VERSION="${DUF_VERSION:-0.9.1}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture
case "$(uname -s)" in
    Linux)
        OS="linux"
        case "$(uname -m)" in
            x86_64)  ARCH="x86_64";;
            aarch64) ARCH="arm64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    Darwin)
        OS="darwin"
        case "$(uname -m)" in
            x86_64)  ARCH="x86_64";;
            arm64)   ARCH="arm64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/muesli/duf/releases/download/v${VERSION}/duf_${VERSION}_${OS}_${ARCH}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading duf ${VERSION} for ${OS}/${ARCH}..."
curl -fsSL "${URL}" -o "${TMPDIR}/duf.tar.gz"
tar -xzf "${TMPDIR}/duf.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/duf" "${BIN_DIR}/duf"
chmod +x "${BIN_DIR}/duf"

echo "duf installed to ${BIN_DIR}/duf"
"${BIN_DIR}/duf" --version
