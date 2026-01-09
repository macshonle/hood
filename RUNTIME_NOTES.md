# Runtime Notes

Notes on WebAssembly runtime compatibility and known issues.

## WasmEdge

**Status**: Installation issues on macOS ARM64 (as of January 2025)

### Issue
The WasmEdge installer (`setup_runtimes.sh --wasmedge`) installs a small wrapper script to `bin/wasmedge` instead of the actual binary. The actual runtime is installed to `~/.wasmedge/bin/wasmedge`.

### To Investigate
- [ ] Verify if WasmEdge works properly on Linux x86_64
- [ ] Check if symlinking `~/.wasmedge/bin/wasmedge` to `bin/wasmedge` resolves the issue
- [ ] Test with manual installation from WasmEdge releases

### Workaround
If you need WasmEdge support, try:
```bash
# Check if WasmEdge was installed to the default location
~/.wasmedge/bin/wasmedge --version

# If that works, you can symlink it
rm bin/wasmedge
ln -s ~/.wasmedge/bin/wasmedge bin/wasmedge
```

## Wasmer

**Status**: Download fails on macOS ARM64 (as of January 2025)

### Issue
The Wasmer installer returns 404 for the ARM64 macOS binary URL.

### To Investigate
- [ ] Check if Wasmer releases have updated their download URLs
- [ ] Verify Wasmer works on Linux x86_64
- [ ] Try installing via Homebrew: `brew install wasmer`

## wabt (wat2wasm)

**Status**: Working, but missing WasmGC syntax support

### Issue
The `wat2wasm` tool from WABT does not fully support WasmGC proposal syntax (`struct.new`, `(ref $Type)`, etc.). This means WasmGC tests cannot be compiled with wabt.

### Impact
- All WasmGC tests fail with "compilation error" even though wasmtime and nodejs support running WasmGC modules
- Need a GC-capable WAT compiler (e.g., `wasm-tools` from Bytecode Alliance)

### To Investigate
- [ ] Add `wasm-tools` as an alternative WAT compiler for GC tests
- [ ] Check wabt roadmap for GC syntax support

## wasmtime

**Status**: Working well for most features

### Supported Proposals
- bulk-memory
- multi-memory
- multi-value
- reference-types
- simd, relaxed-simd
- tail-call
- threads
- memory64
- function-references
- gc (WasmGC)

### Unsupported Proposals (as of v27.0.0)
- **exceptions** - Not yet implemented
- **extended-const** - Not listed in available options

### Impact
Tests in `test/wat/proposals/exceptions/` and `test/wat/proposals/extended-const/` will fail with wasmtime.

## wazero

**Status**: Working

Installed via Go, works well for core WASM and WASI tests.

## Node.js

**Status**: Working

Uses system Node.js with WASI support. Works for core WASM, WASI, and WasmGC (when properly compiled).
