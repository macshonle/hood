# hood
The Hood programming system

A comprehensive WebAssembly conformance test suite covering core WASM, WASI, WASIX, and WasmGC specifications across multiple runtime implementations.

## Overview

Hood provides a multi-runtime testing framework for WebAssembly that goes beyond pure core-WASM conformance to include:

- **Core WebAssembly**: All standard instructions and proposals
- **WASI (WebAssembly System Interface)**: System-level APIs
- **WASIX**: Extended WASI with additional POSIX-like features
- **WasmGC**: Garbage Collection proposal with structs and arrays

Tests are run across a matrix of runtimes to ensure broad compatibility:

| Runtime | Core WASM | WASI | WASIX | WasmGC | Type |
|---------|-----------|------|-------|--------|------|
| **WABT** | ✓ | ✗ | ✗ | ✗ | Interpreter |
| **Wasmtime** | ✓ | ✓ | ✗ | ✓ | Compiler (Cranelift) |
| **Wasmer** | ✓ | ✓ | ✓ | ✗ | Compiler (multi-backend) |
| **wazero** | ✓ | ✓ | ✗ | ✗ | Interpreter (Go) |
| **Node.js** | ✓ | ✓ | ✗ | ✓ | JIT (V8) |
| **WasmEdge** | ✓ | ✓ | ✗ | ✗ | Compiler |

## Quick Start

### 1. Clone with Submodules

```bash
git clone --recursive https://github.com/macshonle/hood.git
cd hood
```

If you already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

### 2. Set Up Runtimes

Install the WebAssembly runtimes:

```bash
# Install core runtimes (WABT, Wasmtime, Wasmer)
./scripts/setup_runtimes.sh

# Or install all runtimes
./scripts/setup_runtimes.sh --all

# Or install specific runtimes
./scripts/setup_runtimes.sh --wasmtime --nodejs
```

### 3. Run Tests

```bash
# Run conformance tests across all available runtimes
./test/run_conformance.sh --all-runtimes

# Test specific category with specific runtime
./test/run_conformance.sh --runtime wasmtime --category wasi

# Test WasmGC with all compatible runtimes
./test/run_conformance.sh --category wasmgc --all-runtimes

# Show runtime capability matrix
./test/run_conformance.sh --matrix
```

## Test Suite Structure

```
test/
├── wat/                      # Core WebAssembly tests
│   ├── core/                 # Core spec (types, numeric, memory, control, etc.)
│   ├── proposals/            # WASM proposals (SIMD, threads, exceptions, etc.)
│   ├── module/               # Module features (imports, exports, data, elem)
│   ├── edge-cases/           # Boundary values and edge cases
│   ├── stress/               # Stress tests (deep nesting, many functions)
│   ├── syntax/               # Syntax variations
│   └── run_tests.sh          # Original WABT-based test runner
├── wasi/                     # WASI tests
│   ├── stdio/                # Standard I/O (stdout, stderr, stdin)
│   ├── filesystem/           # File operations
│   ├── environment/          # Environment variables and arguments
│   ├── clock/                # Time and clock operations
│   ├── random/               # Random number generation
│   └── process/              # Process operations (exit codes)
├── wasix/                    # WASIX tests (Wasmer extensions)
│   ├── networking/           # TCP/UDP sockets
│   ├── threading/            # Threading beyond atomics
│   ├── ipc/                  # Inter-process communication
│   └── advanced-fs/          # Extended filesystem operations
├── wasmgc/                   # WasmGC tests
│   ├── structs/              # Struct types and operations
│   ├── arrays/               # Array types and operations
│   ├── casting/              # Type casting and checking
│   └── subtyping/            # Type hierarchies
├── runtime-matrix.json       # Runtime capability configuration
└── run_conformance.sh        # Multi-runtime test orchestration
```

## Runtime Details

### WABT (WebAssembly Binary Toolkit)

- **Type**: Reference interpreter
- **Use**: Core WASM validation and baseline testing
- **Installation**: Built from submodule via `setup_runtimes.sh`
- **Location**: `external/wabt/build/`

### Wasmtime

- **Type**: Ahead-of-time compiler (Cranelift)
- **Features**: WASI, WasmGC, Component Model
- **Installation**: Downloaded from official releases
- **Best for**: WASI and WasmGC testing

### Wasmer

- **Type**: Multi-backend compiler
- **Features**: WASI, WASIX (extended WASI)
- **Installation**: Official installer script
- **Best for**: WASIX and cross-platform deployment

### wazero

- **Type**: Zero-dependency Go interpreter
- **Features**: WASI support
- **Installation**: `go install`
- **Best for**: Embedded Go applications

### Node.js

- **Type**: JIT compiler (V8)
- **Features**: WASI, WasmGC
- **Installation**: System package manager
- **Best for**: Web and JavaScript integration

### WasmEdge

- **Type**: Optimizing compiler
- **Features**: WASI with cloud-native extensions
- **Installation**: Official installer script
- **Best for**: Edge computing and serverless

## Dependencies

### Required

- **CMake** (3.12+) - For building WABT
- **C++ compiler** - GCC or Clang
- **Git** - For submodule management

### Optional (for additional runtimes)

- **curl** or **wget** - For downloading runtimes
- **Go** (1.18+) - For wazero
- **Node.js** (18+) - For Node.js runtime

## Development

### Adding New Tests

#### Core WASM Tests

Add `.wat` files to appropriate directories in `test/wat/`:

```bash
# Example: Add new numeric test
vim test/wat/core/numeric/my_test.wat
./test/wat/run_tests.sh core/numeric/my_test.wat
```

#### WASI Tests

Add `.wat` files to `test/wasi/` with WASI imports:

```wat
(module
  (import "wasi_snapshot_preview1" "fd_write"
    (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (func (export "_start")
    ;; Your test code
  )
)
```

#### WasmGC Tests

Add `.wat` files to `test/wasmgc/` using GC features:

```wat
(module
  (type $Point (struct (field $x i32) (field $y i32)))
  (func (export "test") (result i32)
    ;; Your test code
  )
)
```

### Running Individual Test Categories

```bash
# Core WASM only
./test/wat/run_tests.sh

# WASI with Wasmtime
./test/run_conformance.sh --runtime wasmtime --category wasi

# All WasmGC tests
./test/run_conformance.sh --category wasmgc --all-runtimes
```

## Continuous Integration

The conformance suite is designed for CI/CD integration:

```yaml
# Example GitHub Actions workflow
- name: Setup Runtimes
  run: ./scripts/setup_runtimes.sh --wasmtime --wasmer

- name: Run Conformance Tests
  run: ./test/run_conformance.sh --all-runtimes
```

## Contributing

Contributions are welcome! Areas of interest:

- Additional test cases for existing categories
- New proposal coverage (typed function references, stack switching, etc.)
- Runtime-specific optimizations
- CI/CD improvements
- Documentation enhancements

## License

See [LICENSE](LICENSE) file for details.

## Resources

- [WebAssembly Specification](https://webassembly.github.io/spec/)
- [WASI Documentation](https://wasi.dev/)
- [WasmGC Proposal](https://github.com/WebAssembly/gc)
- [WASIX Specification](https://wasix.org/)
- [Component Model](https://component-model.bytecodealliance.org/)
