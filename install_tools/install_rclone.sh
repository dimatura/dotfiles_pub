#!/usr/bin/env bash
set -euo pipefail

VERSION="${RCLONE_VERSION:-1.72.1}"
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
        OS="osx"
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

URL="https://github.com/rclone/rclone/releases/download/v${VERSION}/rclone-v${VERSION}-${OS}-${ARCH}.zip"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading rclone ${VERSION} for ${OS}/${ARCH}..."
curl -fsSL "${URL}" -o "${TMPDIR}/rclone.zip"
unzip -q "${TMPDIR}/rclone.zip" -d "${TMPDIR}"

mkdir -p "${BIN_DIR}"
mv "${TMPDIR}/rclone-v${VERSION}-${OS}-${ARCH}/rclone" "${BIN_DIR}/rclone"
chmod +x "${BIN_DIR}/rclone"

echo "rclone installed to ${BIN_DIR}/rclone"
"${BIN_DIR}/rclone" --version
