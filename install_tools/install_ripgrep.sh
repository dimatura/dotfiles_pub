#!/usr/bin/env bash
set -euo pipefail

VERSION="${RIPGREP_VERSION:-15.1.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture to build target triple
case "$(uname -s)" in
    Linux)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-unknown-linux-musl";;
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

URL="https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/ripgrep-${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading ripgrep ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/ripgrep.tar.gz"
tar -xzf "${TMPDIR}/ripgrep.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/ripgrep-${VERSION}-${TARGET}/rg" "${BIN_DIR}/rg"
chmod +x "${BIN_DIR}/rg"

echo "ripgrep installed to ${BIN_DIR}/rg"
"${BIN_DIR}/rg" --version
