# Runtime Notes

Notes on WebAssembly runtime installation and compatibility.

## Installation Overview

All runtimes are installed under `external/` via binary download:

| Runtime | Location | Platform | Install Command |
|---------|----------|----------|-----------------|
| wabt | `external/wabt/` | All | `make install-wabt` |
| wasmtime | `external/wasmtime/` | All | `make install-wasmtime` |
| wazero | `external/wazero/` | All | `make install-wazero` (requires Go) |
| wasmer | `external/wasmer/` | All | `make install-wasmer` |
| wasmedge | `external/wasmedge/` | Linux only | `make install-wasmedge` |
| Node.js | System | All | System package manager |

Use `make install-runtimes` to install all available runtimes at once.

## System Prerequisites

**Required:**
- Make
- curl or wget
- tar

**Optional:**
- Go (for wazero runtime)
- Node.js 18+ (for Node.js runtime tests)

Run `make check-prereqs` to verify prerequisites.

## Platform-Specific Notes

### macOS (ARM64 and x86_64)

Available runtimes:
- wabt (binary download)
- wasmtime (binary download)
- wasmer (binary download)
- wazero (built via Go)

Not available on macOS:
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

**Status**: Working (all platforms)

Downloaded directly from GitHub releases. Supports WASI and WASIX.

### wasmedge

**Status**: Linux only

On macOS, the installer creates a wrapper script that doesn't function correctly.

### Node.js

**Status**: Working (system install)

Uses system Node.js with WASI support. Requires Node.js 18+.

## Cleaning Up

```bash
make clean-runtimes    # Remove all installed runtimes
make clean             # Remove generated .wasm files
make distclean         # Remove everything (runtimes + .wasm files)
```
