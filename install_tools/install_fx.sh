#!/usr/bin/env bash
set -euo pipefail

VERSION="${FX_VERSION:-39.2.0}"
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

URL="https://github.com/antonmedv/fx/releases/download/${VERSION}/fx_${OS}_${ARCH}"

echo "Downloading fx ${VERSION} for ${OS}/${ARCH}..."
mkdir -p "${BIN_DIR}"
curl -fsSL "${URL}" -o "${BIN_DIR}/fx"
chmod +x "${BIN_DIR}/fx"

echo "fx installed to ${BIN_DIR}/fx"
"${BIN_DIR}/fx" --version
