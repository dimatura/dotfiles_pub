#!/usr/bin/env bash
set -euo pipefail

VERSION="${FZF_VERSION:-0.67.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture
case "$(uname -s)" in
    Linux)
        OS="linux"
        case "$(uname -m)" in
            x86_64)  ARCH="amd64";;
            aarch64) ARCH="arm64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    Darwin)
        OS="darwin"
        case "$(uname -m)" in
            x86_64)  ARCH="amd64";;
            arm64)   ARCH="arm64";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-${OS}_${ARCH}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading fzf ${VERSION} for ${OS}/${ARCH}..."
curl -fsSL "${URL}" -o "${TMPDIR}/fzf.tar.gz"
tar -xzf "${TMPDIR}/fzf.tar.gz" -C "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/fzf" "${BIN_DIR}/fzf"
chmod +x "${BIN_DIR}/fzf"

echo "fzf installed to ${BIN_DIR}/fzf"
"${BIN_DIR}/fzf" --version
