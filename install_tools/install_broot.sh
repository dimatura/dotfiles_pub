#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${BIN_DIR:-$HOME/bin}"

# Detect OS and architecture to build target
case "$(uname -s)" in
    Linux)
        case "$(uname -m)" in
            x86_64)  TARGET="x86_64-linux";;
            aarch64) TARGET="aarch64-unknown-linux-gnu";;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    Darwin)
        case "$(uname -m)" in
            arm64)   TARGET="aarch64-apple-darwin";;
            x86_64)  echo "No prebuilt binary for macOS x86_64. Use 'cargo install broot' instead." >&2; exit 1;;
            *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1;;
        esac
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://dystroy.org/broot/download/${TARGET}/broot"

echo "Downloading broot for ${TARGET}..."
mkdir -p "${BIN_DIR}"
curl -fsSL "${URL}" -o "${BIN_DIR}/broot"
chmod +x "${BIN_DIR}/broot"

echo "broot installed to ${BIN_DIR}/broot"
"${BIN_DIR}/broot" --version
