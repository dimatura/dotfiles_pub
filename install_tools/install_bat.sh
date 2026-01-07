#!/usr/bin/env bash
set -euo pipefail

VERSION="${BAT_VERSION:-0.26.1}"
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

URL="https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat-v${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading bat ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/bat.tar.gz"
tar -xzf "${TMPDIR}/bat.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/bat-v${VERSION}-${TARGET}/bat" "${BIN_DIR}/bat"
chmod +x "${BIN_DIR}/bat"

echo "bat installed to ${BIN_DIR}/bat"
"${BIN_DIR}/bat" --version
