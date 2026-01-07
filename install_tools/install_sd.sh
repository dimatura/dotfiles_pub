#!/usr/bin/env bash
set -euo pipefail

VERSION="${SD_VERSION:-1.0.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture to build target triple
case "$(uname -s)" in
    Linux)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-unknown-linux-gnu";;
            aarch64) TARGET="aarch64-unknown-linux-musl";;
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

URL="https://github.com/chmln/sd/releases/download/v${VERSION}/sd-v${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading sd ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/sd.tar.gz"
tar -xzf "${TMPDIR}/sd.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/sd-v${VERSION}-${TARGET}/sd" "${BIN_DIR}/sd"
chmod +x "${BIN_DIR}/sd"

echo "sd installed to ${BIN_DIR}/sd"
"${BIN_DIR}/sd" --version
