#!/usr/bin/env bash
set -euo pipefail

VERSION="${JUST_VERSION:-1.46.0}"
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

URL="https://github.com/casey/just/releases/download/${VERSION}/just-${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading just ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/just.tar.gz"
tar -xzf "${TMPDIR}/just.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/just" "${BIN_DIR}/just"
chmod +x "${BIN_DIR}/just"

echo "just installed to ${BIN_DIR}/just"
"${BIN_DIR}/just" --version
