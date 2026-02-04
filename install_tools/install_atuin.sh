#!/usr/bin/env bash
set -euo pipefail

echo "Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

echo "atuin installed successfully"
