# Hood Test Suite - ARM64 Setup Summary

## What Was Fixed

The setup script has been updated to properly support ARM64 (aarch64) architecture.

### Files Modified:
1. **`scripts/setup_runtimes.sh`** - Added ARM64 detection and support
2. **`scripts/check_prerequisites.sh`** - NEW: Prerequisites checker (created)
3. **`INSTALL_ARM64_LINUX.md`** - NEW: Comprehensive ARM64 Linux installation guide (created)

### Key Changes to setup_runtimes.sh:

1. **Added `detect_arch()` function** (line 51-64)
   - Automatically detects x86_64 vs aarch64/arm64
   - Returns standardized architecture names

2. **Updated Wasmtime installation** (line 100-145)
   - Uses detected architecture in download URL
   - Downloads correct ARM64 binaries
   - Added error handling for architecture-specific downloads

3. **Improved Wasmer installation** (line 147-186)
   - Added architecture detection messaging
   - Better error handling for installation failures

4. **Enhanced WasmEdge installation** (line 244-279)
   - Added architecture detection
   - Better validation of installed binaries

5. **Added system detection output** (line 286-307)
   - Shows detected OS and architecture at startup
   - Warns if unsupported architecture detected

## Current System Status

Based on the prerequisites check:

**✓ Ready:**
- GCC 11.4.0
- Make 4.3
- Git 2.34.1
- curl 7.81.0
- tar/xz tools
- Python 3.10
- WABT submodule initialized
- 99 test files found

**✗ Needs Installation:**
- **CMake** - REQUIRED for building WABT

**⚠ Needs Upgrade:**
- **Node.js v12.22.9** - Too old, need 18+ for WASI/WasmGC tests

**⚠ Optional:**
- **Go** - Only needed for wazero runtime

## Installation Instructions

### Step 1: Check Prerequisites

```bash
cd /workspace
./scripts/check_prerequisites.sh
```

This will show you exactly what's missing.

### Step 2: Install CMake (REQUIRED)

```bash
sudo apt update
sudo apt install -y cmake
```

### Step 3: Upgrade Node.js (RECOMMENDED)

```bash
# Remove old version
sudo apt remove -y nodejs npm

# Install Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node --version  # Should show v20.x or v22.x
```

### Step 4: Install Go (OPTIONAL - only for wazero)

```bash
cd /tmp
wget https://go.dev/dl/go1.22.0.linux-arm64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.0.linux-arm64.tar.gz

# Add to PATH (add to ~/.bashrc for persistence)
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Verify
go version
```

### Step 5: Run Setup Script

```bash
cd /workspace

# For core runtimes (WABT, Wasmtime, Wasmer)
./scripts/setup_runtimes.sh

# OR for all runtimes (requires Go installed)
./scripts/setup_runtimes.sh --all

# OR selective installation
./scripts/setup_runtimes.sh --wasmtime --wasmer --nodejs
```

### Step 6: Verify Installation

```bash
# Show runtime capability matrix
./test/run_conformance.sh --matrix
```

Expected output:
```
Detected system: linux-aarch64

Runtime         Core    WASI    WASIX   WasmGC
----------------------------------------------------------------
wabt (✓)        ✓       ✗       ✗       ✗
wasmtime (✓)    ✓       ✓       ✗       ✓
wasmer (✓)      ✓       ✓       ✓       ✗
wazero (✓)      ✓       ✓       ✗       ✗
nodejs (✓)      ✓       ✓       ✗       ✓
wasmedge (✓)    ✓       ✓       ✗       ✗
```

### Step 7: Run Tests

```bash
# Run all tests with all available runtimes
./test/run_conformance.sh --all-runtimes

# Run specific category
./test/run_conformance.sh --category core --all-runtimes
./test/run_conformance.sh --category wasi --all-runtimes
./test/run_conformance.sh --category wasmgc --all-runtimes

# Run with specific runtime
./test/run_conformance.sh --runtime wasmtime --category wasi
```

## Quick Reference

### Minimum Setup (Just to Test)
```bash
# Install only CMake
sudo apt install -y cmake

# Build WABT
cd /workspace
./scripts/setup_runtimes.sh --wabt

# Run basic tests
./test/run_conformance.sh --runtime wabt --category core
```

### Recommended Setup (Most Coverage)
```bash
# Install prerequisites
sudo apt install -y cmake
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install core runtimes
cd /workspace
./scripts/setup_runtimes.sh

# Run comprehensive tests
./test/run_conformance.sh --all-runtimes
```

### Full Setup (All Runtimes)
```bash
# Install all prerequisites including Go
sudo apt install -y cmake
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
# Install Go (see Step 4 above)

# Install all runtimes
cd /workspace
./scripts/setup_runtimes.sh --all

# Run complete test matrix
./test/run_conformance.sh --all-runtimes
```

## Test Categories

Your system has tests for:

1. **Core WASM** (test/wat/core/) - Basic WebAssembly instructions
2. **Proposals** (test/wat/proposals/) - SIMD, threads, exceptions, tail-call, etc.
3. **Edge Cases** (test/wat/edge-cases/) - Boundary conditions
4. **Stress** (test/wat/stress/) - Deep nesting, many functions
5. **WASI** (test/wasi/) - stdio, filesystem, clock, random, process
6. **WASIX** (test/wasix/) - networking, threading, IPC (Wasmer only)
7. **WasmGC** (test/wasmgc/) - structs, arrays, casting, subtyping

Total: **99 test files**

## Runtime Coverage Matrix

| Runtime | Core | Proposals | WASI | WASIX | WasmGC | ARM64 |
|---------|------|-----------|------|-------|--------|-------|
| WABT | ✓ | ✓ | ✗ | ✗ | ✗ | ✓ |
| Wasmtime | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ |
| Wasmer | ✓ | Partial | ✓ | ✓ | ✗ | ✓ |
| wazero | ✓ | Partial | ✓ | ✗ | ✗ | ✓ |
| Node.js | ✓ | Partial | ✓ | ✗ | ✓ | ✓ |
| WasmEdge | ✓ | Partial | ✓ | ✗ | ✗ | ✓ |

**All runtimes support ARM64!**

## Troubleshooting

### Script shows wrong architecture
```bash
uname -m  # Should show: aarch64
```

If it shows something else, your system might need the scripts adjusted.

### Downloads fail with 404 errors
The architecture detection may have failed. Check:
```bash
./scripts/setup_runtimes.sh
# First line after "WebAssembly Runtime Setup" should show:
# "Detected system: linux-aarch64"
```

### WABT build fails
```bash
# Ensure build tools are installed
sudo apt install -y build-essential cmake

# Try manual build
cd /workspace/external/wabt
rm -rf build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

### Permission denied errors
```bash
# Ensure scripts are executable
chmod +x /workspace/scripts/*.sh
chmod +x /workspace/test/run_conformance.sh
```

## Next Steps

After setup is complete:

1. **Run the test matrix**
   ```bash
   ./test/run_conformance.sh --all-runtimes
   ```

2. **Check results** - The script will show PASS/FAIL/SKIP for each test

3. **Explore specific areas**
   ```bash
   # Focus on WASI tests
   ./test/run_conformance.sh --category wasi --all-runtimes

   # Focus on WasmGC
   ./test/run_conformance.sh --category wasmgc --all-runtimes
   ```

4. **Add your own tests** - See README.md for how to add new test cases

## Summary

The setup script is now ARM64-ready and will:
- ✓ Detect your ARM64 architecture automatically
- ✓ Download ARM64-specific binaries where available
- ✓ Build from source (WABT) with correct architecture
- ✓ Provide clear error messages if something fails
- ✓ Support all major WebAssembly runtimes on ARM64

You're all set to run the full Hood conformance test suite on ARM64!
