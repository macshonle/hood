# WebAssembly Text Format Test Suite

A comprehensive test suite for WebAssembly text format (.wat) compilers and interpreters.

## Structure

```
test/wat/
├── core/                    # Core WebAssembly features
│   ├── types/               # Type constants (i32, i64, f32, f64)
│   ├── numeric/             # Numeric operations (arithmetic, bitwise, comparison)
│   ├── memory/              # Memory operations (load, store, grow)
│   ├── control/             # Control flow (block, loop, if, br, br_table)
│   ├── functions/           # Function definitions and calls
│   ├── tables/              # Table operations
│   └── globals/             # Global variables
├── module/                  # Module-level features
│   ├── imports/             # Import declarations
│   ├── exports/             # Export declarations
│   ├── start/               # Start function
│   ├── data/                # Data segments
│   └── elem/                # Element segments
├── proposals/               # WebAssembly proposals
│   ├── simd/                # SIMD (v128) operations
│   ├── threads/             # Threads and atomics
│   ├── exceptions/          # Exception handling
│   ├── tail-call/           # Tail calls
│   ├── bulk-memory/         # Bulk memory operations
│   ├── reference-types/     # Reference types (funcref, externref)
│   ├── multi-value/         # Multiple return values
│   ├── sign-extension/      # Sign extension operators
│   ├── nontrapping-float-to-int/  # Saturating conversions
│   ├── mutable-globals/     # Mutable global exports
│   ├── memory64/            # 64-bit memory
│   ├── multi-memory/        # Multiple memories
│   ├── extended-const/      # Extended constant expressions
│   ├── relaxed-simd/        # Relaxed SIMD
│   └── function-references/ # Typed function references
├── syntax/                  # Syntax tests
│   ├── comments/            # Comment styles
│   ├── whitespace/          # Whitespace handling
│   ├── names/               # Identifier names
│   └── literals/            # Numeric and string literals
├── edge-cases/              # Edge cases and boundary values
├── stress/                  # Stress tests
└── run_tests.sh             # Test runner script
```

## Running Tests

### Prerequisites

Build the wabt tools first:

```bash
cd external/wabt
mkdir build && cd build
cmake ..
make wat2wasm wasm-interp
```

### Run All Tests

```bash
cd test/wat
./run_tests.sh
```

### Run Specific Tests

```bash
# Test a specific directory
./run_tests.sh core/numeric

# Test a specific file
./run_tests.sh core/types/i32_const.wat

# Test a proposal
./run_tests.sh proposals/simd
```

## Proposal Support

Different proposals require different flags:

| Proposal | Flag | Default |
|----------|------|---------|
| SIMD | --disable-simd (to disable) | Enabled |
| Bulk Memory | --disable-bulk-memory | Enabled |
| Reference Types | --disable-reference-types | Enabled |
| Multi-Value | --disable-multi-value | Enabled |
| Sign Extension | --disable-sign-extension | Enabled |
| Mutable Globals | --disable-mutable-globals | Enabled |
| Saturating Float-to-Int | --disable-saturating-float-to-int | Enabled |
| Threads | --enable-threads | Disabled |
| Tail Call | --enable-tail-call | Disabled |
| Exceptions | --enable-exceptions | Disabled |
| Memory64 | --enable-memory64 | Disabled |
| Multi-Memory | --enable-multi-memory | Disabled |
| Extended Const | --enable-extended-const | Disabled |
| Relaxed SIMD | --enable-relaxed-simd | Disabled |
| Function References | --enable-function-references | Disabled |

## Test File Format

Each `.wat` file is a self-contained WebAssembly module. Tests export functions that can be called by the interpreter.

Example:
```wat
(module
  (func (export "add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)
)
```

## Coverage

This test suite covers:

- All core instructions (numeric, memory, control flow)
- All value types (i32, i64, f32, f64, v128, funcref, externref)
- Module structure (functions, tables, memories, globals)
- Imports and exports
- Data and element segments
- All standard proposals supported by wabt
- Edge cases (boundary values, special float values, overflow)
- Stress tests (deep nesting, many functions/locals)
- Syntax variations (comments, whitespace, literals)

## Notes

- Some tests in `module/imports/` require host bindings and are skipped by the test runner
- Tests for disabled-by-default proposals require appropriate flags
- Some tests may trap intentionally (e.g., unreachable, division by zero)
