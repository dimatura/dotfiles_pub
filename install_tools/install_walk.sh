#!/usr/bin/env bash
set -euo pipefail

VERSION="${WALK_VERSION:-1.13.0}"
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

URL="https://github.com/antonmedv/walk/releases/download/v${VERSION}/walk_${OS}_${ARCH}"

echo "Downloading walk ${VERSION} for ${OS}/${ARCH}..."
mkdir -p "${BIN_DIR}"
curl -fsSL "${URL}" -o "${BIN_DIR}/walk"
chmod +x "${BIN_DIR}/walk"

echo "walk installed to ${BIN_DIR}/walk"
"${BIN_DIR}/walk" --version
