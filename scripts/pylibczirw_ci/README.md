# pylibCZIrw Python 3.14 Wheels

Pre-built wheels for pylibCZIrw with Python 3.14 support.

## Background

pylibCZIrw does not yet publish official Python 3.14 wheels. These were built
from source (v6.0.1) with pybind11 v3.0.0+ which adds Python 3.14 support.

## Building locally

```bash
# Install Python 3.14 (update version as needed)
uv python install cpython-3.14.0rc2

# Build the wheel
./scripts/build_pylibczirw_wheel.sh 6.0.1 python3.14
```

## CI workflow

The `build-wheels-py314.yml` workflow builds wheels for:

- Linux x86_64
- Windows x64

Trigger it manually via GitHub Actions workflow dispatch.
