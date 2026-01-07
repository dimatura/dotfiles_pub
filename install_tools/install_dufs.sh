#!/usr/bin/env bash
set -euo pipefail

VERSION="${DUFS_VERSION:-0.45.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture to build target triple
case "$(uname -s)" in
    Linux)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-unknown-linux-musl";;
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

URL="https://github.com/sigoden/dufs/releases/download/v${VERSION}/dufs-v${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading dufs ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/dufs.tar.gz"
tar -xzf "${TMPDIR}/dufs.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/dufs" "${BIN_DIR}/dufs"
chmod +x "${BIN_DIR}/dufs"

echo "dufs installed to ${BIN_DIR}/dufs"
"${BIN_DIR}/dufs" --version
