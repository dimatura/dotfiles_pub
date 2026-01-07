#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
    Linux)
        echo "Installing tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
        ;;
    Darwin)
        echo "To install Tailscale on macOS, visit: https://tailscale.com/download/mac"
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac
