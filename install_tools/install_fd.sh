#!/usr/bin/env bash
set -euo pipefail

VERSION="${FD_VERSION:-10.3.0}"
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

URL="https://github.com/sharkdp/fd/releases/download/v${VERSION}/fd-v${VERSION}-${TARGET}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading fd ${VERSION} for ${TARGET}..."
curl -fsSL "${URL}" -o "${TMPDIR}/fd.tar.gz"
tar -xzf "${TMPDIR}/fd.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/fd-v${VERSION}-${TARGET}/fd" "${BIN_DIR}/fd"
chmod +x "${BIN_DIR}/fd"

echo "fd installed to ${BIN_DIR}/fd"
"${BIN_DIR}/fd" --version
