#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
    Linux)
        echo "Installing stow via apt..."
        sudo apt update
        sudo apt install -y stow
        ;;
    Darwin)
        echo "Installing stow via brew..."
        brew install stow
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

echo "stow installed successfully"
stow --version
