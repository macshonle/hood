# WebAssembly GC Test Suite

Tests for WebAssembly Garbage Collection (WasmGC) proposal.

## What is WasmGC?

WasmGC extends WebAssembly with managed memory and garbage collection, enabling:

- **Structured Types**: Structs and arrays as first-class types
- **Managed References**: GC-managed reference types
- **Subtyping**: Type hierarchies and inheritance
- **Type Casting**: Dynamic type checking and casting
- **Better Language Integration**: Direct support for GC languages (Java, C#, Go, etc.)

## Structure

```
test/wasmgc/
├── structs/           # Struct types and operations
├── arrays/            # Array types and operations
├── casting/           # Type casting and checking
├── subtyping/         # Type hierarchies and inheritance
└── README.md          # This file
```

## WasmGC Features

### Type Definitions
- `type` - Define struct and array types
- `rec` - Recursive type groups
- `sub` - Subtype relationships

### Struct Operations
- `struct.new` - Create struct instance
- `struct.get` - Get field value
- `struct.set` - Set mutable field value

### Array Operations
- `array.new` - Create array
- `array.new_fixed` - Create array with fixed size
- `array.get` - Get element
- `array.set` - Set element
- `array.len` - Get array length

### Reference Types
- `(ref $type)` - Non-nullable reference
- `(ref null $type)` - Nullable reference
- `anyref` - Top type for all references
- `eqref` - Reference that supports equality
- `i31ref` - Unboxed 31-bit integer

### Casting and Type Checking
- `ref.test` - Test reference type
- `ref.cast` - Cast reference type
- `ref.null` - Create null reference
- `ref.is_null` - Check if reference is null
- `ref.as_non_null` - Assert reference is non-null

## Compatible Runtimes

WasmGC support is available in:
- **Wasmtime** - Full WasmGC support (with `--wasm-features=gc`)
- **Node.js** - V8 engine has WasmGC support (v8 flags may be needed)
- **Chrome/V8** - WasmGC enabled by default in recent versions
- **Firefox/SpiderMonkey** - WasmGC support available

## Running Tests

```bash
# Run WasmGC tests with Wasmtime
./run_wasmgc_tests.sh --runtime wasmtime

# Run with Node.js
./run_wasmgc_tests.sh --runtime nodejs

# Test specific category
./run_wasmgc_tests.sh --category structs
```

## Test Format

WasmGC tests use the new type syntax:

```wat
(module
  ;; Define a struct type
  (type $Point (struct (field $x f64) (field $y f64)))

  ;; Create and use struct
  (func (export "distance") (result f64)
    (local $p (ref $Point))
    (local.set $p
      (struct.new $Point (f64.const 3.0) (f64.const 4.0)))
    ;; ... calculate distance
  )
)
```

## Status

WasmGC is in active development and standardization. Test coverage includes:
- Basic struct and array operations
- Reference type handling
- Subtyping and casting
- Integration with existing WebAssembly features

Some advanced features may require specific runtime versions or flags.
