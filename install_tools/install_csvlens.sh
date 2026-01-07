#!/usr/bin/env bash
set -euo pipefail

VERSION="${CSVLENS_VERSION:-0.15.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture to build target triple
case "$(uname -s)" in
    Linux)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-unknown-linux-gnu";;
            aarch64) TARGET="aarch64-unknown-linux-gnu";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    Darwin)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-apple-darwin";;
            arm64)   TARGET="aarch64-apple-darwin";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/YS-L/csvlens/releases/download/v${VERSION}/csvlens-${TARGET}.tar.xz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading csvlens ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/csvlens.tar.xz"
tar -xJf "${TMPDIR}/csvlens.tar.xz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/csvlens" "${BIN_DIR}/csvlens"
chmod +x "${BIN_DIR}/csvlens"

echo "csvlens installed to ${BIN_DIR}/csvlens"
"${BIN_DIR}/csvlens" --version
