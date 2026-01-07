bin_dir := "~/bin"

lazygit_version := "0.58.0"

lazygit_os := if os() == "macos" { "Darwin" } else if os() == "linux" { "Linux" } else { error("Unsupported OS") }
lazygit_arch := if arch() == "aarch64" { "arm64" } else if arch() == "x86_64" { "x86_64" } else { error("Unsupported architecture") }
lazygit_url := "https://github.com/jesseduffield/lazygit/releases/download/v" + lazygit_version + "/lazygit_" + lazygit_version + "_" + lazygit_os + "_" + lazygit_arch + ".tar.gz"

# Install lazygit
install-lazygit:
    #!/usr/bin/env bash
    set -euo pipefail

    TMPDIR=$(mktemp -d)
    trap "rm -rf ${TMPDIR}" EXIT

    echo "Downloading lazygit {{lazygit_version}} for {{lazygit_os}}/{{lazygit_arch}}..."
    curl -fsSL "{{lazygit_url}}" -o "${TMPDIR}/lazygit.tar.gz"
    tar -xzf "${TMPDIR}/lazygit.tar.gz" -C "${TMPDIR}"

    mkdir -p {{bin_dir}}
    mv "${TMPDIR}/lazygit" {{bin_dir}}/lazygit
    chmod +x {{bin_dir}}/lazygit

    echo "lazygit installed to {{bin_dir}}/lazygit"
    {{bin_dir}}/lazygit --version
