# Runtime Notes

Notes on WebAssembly runtime installation and compatibility.

## Installation Overview

All project-local runtimes are installed under `external/`:

| Runtime | Location | Platform | Install Command |
|---------|----------|----------|-----------------|
| wabt | `external/wabt/` | All | `make init build` (git submodule) |
| wasmtime | `external/wasmtime/` | All | `make install-wasmtime` |
| wazero | `external/wazero/` | All | `make install-wazero` (requires Go) |
| wasmer | `external/wasmer/` | Linux only | `make install-wasmer` |
| wasmedge | `external/wasmedge/` | Linux only | `make install-wasmedge` |
| Node.js | System | All | System package manager |

## System Prerequisites

These must be installed system-wide before building:

**Required:**
- CMake 3.12+ (for building wabt)
- C++ compiler (gcc or clang)
- Make
- Git
- curl or wget

**Optional:**
- Go (for wazero runtime)
- Node.js 18+ (for Node.js runtime tests)

Run `make check-prereqs` to verify prerequisites.

## Platform-Specific Notes

### macOS (ARM64 and x86_64)

Available runtimes:
- wabt (built from source)
- wasmtime (binary download)
- wazero (built via Go)

Not available on macOS:
- **wasmer** - ARM64 binary URLs return 404
- **wasmedge** - Installer doesn't work correctly on macOS

### Linux (x86_64 and aarch64)

All runtimes are available.

## Runtime Details

### wabt (wat2wasm)

**Status**: Working, but missing WasmGC syntax support

The `wat2wasm` tool does not fully support WasmGC proposal syntax (`struct.new`, `(ref $Type)`, etc.). WasmGC tests are skipped during conformance testing.

To investigate:
- [ ] Add `wasm-tools` as an alternative WAT compiler for GC tests
- [ ] Check wabt roadmap for GC syntax support

### wasmtime

**Status**: Working well for most features

**Supported Proposals:**
- bulk-memory, multi-memory, multi-value
- reference-types, function-references
- simd, relaxed-simd
- tail-call, threads, memory64
- gc (WasmGC)

**Unsupported Proposals (as of v27.0.0):**
- exceptions - Not yet implemented
- extended-const - Not available

Tests for unsupported proposals are automatically skipped.

### wazero

**Status**: Working

Requires Go to be installed. Works well for core WASM and WASI tests.

### wasmer

**Status**: Linux only

On macOS, the Wasmer installer returns 404 for ARM64 binary URLs.

### wasmedge

**Status**: Linux only

On macOS, the installer creates a wrapper script that doesn't function correctly.

### Node.js

**Status**: Working (system install)

Uses system Node.js with WASI support. Requires Node.js 18+.

## Cleaning Up

```bash
make clean-runtimes    # Remove all installed runtimes
make clean             # Remove wabt build and .wasm files
make distclean         # Remove everything including submodules
```
