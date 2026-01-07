#!/usr/bin/env bash
set -euo pipefail

VERSION="${CROC_VERSION:-10.3.1}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture
case "$(uname -s)" in
    Linux)
        OS="Linux"
        case "$(uname -m)" in
            x86_64)  ARCH="64bit";;
            aarch64) ARCH="ARM64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    Darwin)
        OS="macOS"
        case "$(uname -m)" in
            x86_64)  ARCH="64bit";;
            arm64)   ARCH="ARM64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/schollz/croc/releases/download/v${VERSION}/croc_v${VERSION}_${OS}-${ARCH}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading croc ${VERSION} for ${OS}/${ARCH}..."
curl -fsSL "${URL}" -o "${TMPDIR}/croc.tar.gz"
tar -xzf "${TMPDIR}/croc.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/croc" "${BIN_DIR}/croc"
chmod +x "${BIN_DIR}/croc"

echo "croc installed to ${BIN_DIR}/croc"
"${BIN_DIR}/croc" --version
