#!/usr/bin/env bash
set -euo pipefail

VERSION="${UGREP_VERSION:-7.7.0}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"
JOBS="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)}"

case "$(uname -s)" in
    Linux|Darwin) ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/Genivia/ugrep/archive/refs/tags/v${VERSION}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading ugrep ${VERSION} source..."
curl -fsSL "${URL}" -o "${TMPDIR}/ugrep.tar.gz"
tar -xzf "${TMPDIR}/ugrep.tar.gz" -C "${TMPDIR}"

cd "${TMPDIR}/ugrep-${VERSION}"
echo "Building ugrep..."
MAKEFLAGS="-j${JOBS}" ./build.sh

mkdir -p "${BIN_DIR}"
mv bin/ugrep "${BIN_DIR}/ugrep"
chmod +x "${BIN_DIR}/ugrep"
ln -sf ugrep "${BIN_DIR}/ug"

echo "ugrep installed to ${BIN_DIR}/ugrep"
"${BIN_DIR}/ugrep" --version
