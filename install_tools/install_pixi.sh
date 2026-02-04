#!/usr/bin/env bash
set -euo pipefail

echo "Installing pixi..."
curl -fsSL https://pixi.sh/install.sh | sh

echo "pixi installed successfully"
echo "Restart your terminal or shell to use pixi"
