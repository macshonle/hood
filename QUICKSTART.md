# Quick Start Guide

Get the Hood conformance suite running in 5 minutes.

## Prerequisites

```bash
# Check you have the basics
cmake --version    # Need 3.12+
gcc --version      # Or clang
git --version
```

## Installation

### Step 1: Clone and Initialize

```bash
git clone --recursive https://github.com/macshonle/hood.git
cd hood
```

Already cloned? Initialize submodules:

```bash
git submodule update --init --recursive
```

### Step 2: Install Runtimes

**Option A: Install core runtimes (recommended)**

```bash
./scripts/setup_runtimes.sh
```

This installs:
- WABT (reference interpreter)
- Wasmtime (WASI + WasmGC)
- Wasmer (WASI + WASIX)

**Option B: Install all runtimes**

```bash
./scripts/setup_runtimes.sh --all
```

Adds wazero, Node.js check, and WasmEdge.

**Option C: Install specific runtimes**

```bash
./scripts/setup_runtimes.sh --wasmtime --nodejs
```

## Running Tests

### Test Everything

```bash
./test/run_conformance.sh --all-runtimes
```

### Test Specific Categories

```bash
# Core WebAssembly
./test/run_conformance.sh --category core

# WASI system interface
./test/run_conformance.sh --category wasi

# WasmGC garbage collection
./test/run_conformance.sh --category wasmgc

# WASIX (Wasmer extensions)
./test/run_conformance.sh --category wasix
```

### Test with Specific Runtime

```bash
# Wasmtime
./test/run_conformance.sh --runtime wasmtime --category wasi

# Wasmer
./test/run_conformance.sh --runtime wasmer --category wasix

# Node.js
./test/run_conformance.sh --runtime nodejs --category wasmgc
```

### Original WABT-only Tests

```bash
cd test/wat
./run_tests.sh
```

## View Capabilities

```bash
./test/run_conformance.sh --matrix
```

Shows which runtimes support which features:

```
Runtime         Core    WASI    WASIX   WasmGC
----------------------------------------------------------------
wabt (✓)        ✓       ✗       ✗       ✗
wasmtime (✓)    ✓       ✓       ✗       ✓
wasmer (✓)      ✓       ✓       ✓       ✗
wazero (✓)      ✓       ✓       ✗       ✗
nodejs (✓)      ✓       ✓       ✗       ✓
wasmedge (✗)    ✓       ✓       ✗       ✗
```

## Understanding Output

```bash
PASS test/wasi/stdio/hello_stdout.wat [wasmtime]     # Test passed
SKIP test/wat/module/imports/basic.wat [wabt]        # Test skipped
FAIL test/wasmgc/arrays/bad.wat [nodejs]             # Test failed
```

## Common Issues

### "wat2wasm not found"

WABT hasn't been built yet:

```bash
cd external/wabt
mkdir -p build && cd build
cmake .. && make
```

### "Runtime not found"

Install the missing runtime:

```bash
./scripts/setup_runtimes.sh --wasmtime
# or
./scripts/setup_runtimes.sh --all
```

### "cmake not found"

Install CMake:

```bash
# Ubuntu/Debian
sudo apt install cmake

# macOS
brew install cmake

# Fedora
sudo dnf install cmake
```

## Next Steps

### Add Your Own Tests

Create a new WAT file:

```bash
# Core WASM test
vim test/wat/core/numeric/my_test.wat

# WASI test
vim test/wasi/filesystem/my_test.wat

# WasmGC test
vim test/wasmgc/structs/my_test.wat
```

Run your test:

```bash
./test/run_conformance.sh --category wasi --all-runtimes
```

### Integrate with CI

Add to your `.github/workflows/test.yml`:

```yaml
name: WASM Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Setup Runtimes
        run: ./scripts/setup_runtimes.sh --wasmtime --wasmer

      - name: Run Tests
        run: ./test/run_conformance.sh --all-runtimes
```

### Explore Documentation

- **Full README**: [README.md](README.md)
- **Upgrade Details**: [CONFORMANCE_UPGRADE.md](CONFORMANCE_UPGRADE.md)
- **WASI Tests**: [test/wasi/README.md](test/wasi/README.md)
- **WasmGC Tests**: [test/wasmgc/README.md](test/wasmgc/README.md)
- **WASIX Tests**: [test/wasix/README.md](test/wasix/README.md)

## Help

```bash
# Setup script help
./scripts/setup_runtimes.sh --help

# Test runner help
./test/run_conformance.sh --help

# Original test runner
./test/wat/run_tests.sh --help
```

## Summary Commands

```bash
# Complete setup and test
git clone --recursive https://github.com/macshonle/hood.git
cd hood
./scripts/setup_runtimes.sh
./test/run_conformance.sh --all-runtimes

# That's it! 🎉
```
