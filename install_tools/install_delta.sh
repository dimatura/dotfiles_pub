#!/usr/bin/env bash
set -euo pipefail

VERSION="${DELTA_VERSION:-0.18.2}"
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

URL="https://github.com/dandavison/delta/releases/download/${VERSION}/delta-${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading delta ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/delta.tar.gz"
tar -xzf "${TMPDIR}/delta.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/delta-${VERSION}-${TARGET}/delta" "${BIN_DIR}/delta"
chmod +x "${BIN_DIR}/delta"

echo "delta installed to ${BIN_DIR}/delta"
"${BIN_DIR}/delta" --version
