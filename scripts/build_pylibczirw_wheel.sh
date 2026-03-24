#!/usr/bin/env bash
# Build a pylibCZIrw wheel for Python 3.14 from source.
#
# Prerequisites:
#   - Python 3.14 (install via: uv python install cpython-3.14.0rc2)
#   - cmake, gcc/g++ (C++17), libssl-dev, zlib1g-dev
#   - git (for cloning with submodules)
#
# Usage:
#   ./scripts/build_pylibczirw_wheel.sh [VERSION] [PYTHON]
#
# Examples:
#   ./scripts/build_pylibczirw_wheel.sh 6.0.1 python3.14
#   ./scripts/build_pylibczirw_wheel.sh          # defaults: 6.0.1, python3.14

set -euo pipefail

VERSION="${1:-6.0.1}"
PYTHON="${2:-python3.14}"
WORKDIR="/tmp/pylibczirw-build-$$"
OUTDIR="${3:-$(pwd)/dist}"

echo "Building pylibCZIrw ${VERSION} wheel for $("${PYTHON}" --version)"
echo "Output directory: ${OUTDIR}"

# Clone repository
echo "Cloning pylibczirw v${VERSION}..."
git clone --recursive --branch "v${VERSION}" --depth 1 \
    https://github.com/ZEISS/pylibczirw.git "${WORKDIR}"

cd "${WORKDIR}"

# Set version in setup.py (semantic-release sets this in CI)
sed -i "s/VERSION = \"0.0.0\"/VERSION = \"${VERSION}\"/" setup.py

# Create virtual environment
echo "Creating build environment..."
uv venv --python="${PYTHON}" .venv
uv pip install --python .venv/bin/python \
    build setuptools wheel packaging xmltodict validators numpy cmake

# Build the wheel
echo "Building wheel..."
.venv/bin/python -m build --wheel

# Copy output
mkdir -p "${OUTDIR}"
cp dist/*.whl "${OUTDIR}/"

WHEEL_NAME="$(basename dist/*.whl)"
echo ""
echo "Success! Built: ${OUTDIR}/${WHEEL_NAME}"

# Cleanup
rm -rf "${WORKDIR}"
