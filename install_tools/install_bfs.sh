#!/usr/bin/env bash
set -euo pipefail

VERSION="${BFS_VERSION:-4.1}"
BIN_DIR="${BIN_DIR:-$HOME/bin}"
JOBS="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)}"

case "$(uname -s)" in
    Linux|Darwin) ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

URL="https://github.com/tavianator/bfs/releases/download/${VERSION}/bfs-${VERSION}.tar.gz"

TMPDIR=$(mktemp -d)
trap "rm -rf ${TMPDIR}" EXIT

echo "Downloading bfs ${VERSION} source..."
curl -fsSL "${URL}" -o "${TMPDIR}/bfs.tar.gz"
mkdir -p "${TMPDIR}/src"
tar -xzf "${TMPDIR}/bfs.tar.gz" -C "${TMPDIR}/src"

cd "${TMPDIR}/src"
echo "Configuring bfs..."
./configure --enable-release
echo "Building bfs..."
make -j"${JOBS}"

mkdir -p "${BIN_DIR}"
mv bin/bfs "${BIN_DIR}/bfs"
chmod +x "${BIN_DIR}/bfs"

echo "bfs installed to ${BIN_DIR}/bfs"
"${BIN_DIR}/bfs" --version
