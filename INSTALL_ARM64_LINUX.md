# ARM64 Installation Guide

This guide covers running the Hood test suite on ARM64/aarch64 systems.

## System Detected
- Architecture: ARM64 (aarch64)
- OS: Linux (Ubuntu 22.04)
- Node.js: v12.22.9 (needs upgrade to 18+)

## Changes Made to Setup Script

The `scripts/setup_runtimes.sh` has been updated to properly support ARM64:

### Key Changes:
1. **Added `detect_arch()` function** - Detects x86_64 vs aarch64 architecture
2. **Updated Wasmtime installation** - Downloads correct ARM64 binaries
3. **Improved Wasmer installation** - Added architecture detection and better error handling
4. **Enhanced WasmEdge installation** - Added architecture detection and validation
5. **Added system detection output** - Shows detected OS and architecture at startup

## Prerequisites Installation

### 1. Install CMake (REQUIRED)
```bash
sudo apt update
sudo apt install -y cmake
```

### 2. Upgrade Node.js (REQUIRED for Node.js runtime tests)
```bash
# Remove old Node.js
sudo apt remove -y nodejs npm

# Install Node.js 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node --version  # Should show v20.x or v22.x
```

### 3. Install Go (Optional - only needed for wazero runtime)
```bash
# Download Go for ARM64
cd /tmp
wget https://go.dev/dl/go1.22.0.linux-arm64.tar.gz

# Install
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.0.linux-arm64.tar.gz

# Add to PATH (add to ~/.bashrc for persistence)
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Verify
go version  # Should show go1.22.0
```

## Installation Steps

### Quick Start (Core Runtimes Only)
```bash
# Install prerequisites
sudo apt update
sudo apt install -y cmake

# Upgrade Node.js (see above)

# Run setup script
cd /workspace
./scripts/setup_runtimes.sh
```

This installs:
- WABT (built from source)
- Wasmtime (downloads ARM64 binary)
- Wasmer (installs via official installer)

### Full Installation (All Runtimes)
```bash
# Install all prerequisites including Go

# Run setup with --all flag
cd /workspace
./scripts/setup_runtimes.sh --all
```

This installs all 6 runtimes:
- WABT
- Wasmtime
- Wasmer
- wazero (requires Go)
- Node.js (checks existing installation)
- WasmEdge

### Selective Installation
```bash
# Install specific runtimes
./scripts/setup_runtimes.sh --wasmtime --wasmer --nodejs
```

## Verify Installation

```bash
# Check what's installed
./test/run_conformance.sh --matrix
```

Expected output:
```
Runtime         Core    WASI    WASIX   WasmGC
----------------------------------------------------------------
wabt (✓)        ✓       ✗       ✗       ✗
wasmtime (✓)    ✓       ✓       ✗       ✓
wasmer (✓)      ✓       ✓       ✓       ✗
wazero (✓)      ✓       ✓       ✗       ✗
nodejs (✓)      ✓       ✓       ✗       ✓
wasmedge (✓)    ✓       ✓       ✗       ✗
```

## Running Tests

### Run All Tests with All Runtimes
```bash
./test/run_conformance.sh --all-runtimes
```

### Run Specific Category
```bash
# Core WASM tests
./test/run_conformance.sh --category core --all-runtimes

# WASI tests
./test/run_conformance.sh --category wasi --all-runtimes

# WasmGC tests
./test/run_conformance.sh --category wasmgc --all-runtimes

# WASIX tests (Wasmer only)
./test/run_conformance.sh --category wasix --runtime wasmer
```

### Run Specific Runtime
```bash
# Test with Wasmtime only
./test/run_conformance.sh --runtime wasmtime --category wasi

# Test with Node.js only
./test/run_conformance.sh --runtime nodejs --category core
```

## Troubleshooting

### CMake Not Found
```bash
sudo apt install cmake
```

### WABT Build Fails
```bash
# Check you have build tools
sudo apt install build-essential

# Try manual build
cd /workspace/external/wabt
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

### Node.js Version Too Old
You need Node.js 18+ for WASI and WasmGC support. Follow upgrade steps above.

### Go Not Found (for wazero)
wazero is optional. Skip it or install Go as shown above.

### Architecture Mismatch Errors
The script now auto-detects ARM64. If you see x86_64 download errors, verify:
```bash
uname -m  # Should show: aarch64
./scripts/setup_runtimes.sh  # Should show: Detected system: linux-aarch64
```

### Permission Issues
```bash
# Scripts should already be executable, but if needed:
chmod +x /workspace/scripts/setup_runtimes.sh
chmod +x /workspace/test/run_conformance.sh
```

## ARM64 Runtime Support Status

All runtimes have ARM64 support:

| Runtime | ARM64 Support | Installation Method |
|---------|---------------|---------------------|
| WABT | ✅ Full | Built from source (works on any arch) |
| Wasmtime | ✅ Full | Pre-built ARM64 binaries available |
| Wasmer | ✅ Full | Installer detects ARM64 automatically |
| wazero | ✅ Full | Go compiles to native ARM64 |
| Node.js | ✅ Full | Native ARM64 packages available |
| WasmEdge | ✅ Full | Installer detects ARM64 automatically |

## Summary

The setup script has been fixed to properly handle ARM64 architecture. All WebAssembly runtimes support ARM64, and the script will now:

1. Detect your architecture automatically
2. Download/build the correct binaries for ARM64
3. Provide clear error messages if something fails
4. Validate installation success

You can now run the full Hood test matrix on ARM64 systems!
