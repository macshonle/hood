# WASI (WebAssembly System Interface) Test Suite

Comprehensive tests for WASI Preview 1 and Preview 2 implementations.

## Structure

```
test/wasi/
├── filesystem/        # File system operations (path_open, fd_read, fd_write, fd_readdir)
├── stdio/             # Standard I/O (stdin, stdout, stderr)
├── environment/       # Environment variables and args
├── clock/             # Time and clock operations
├── random/            # Random number generation (random_get)
├── process/           # Process operations (proc_exit, exit codes)
└── README.md          # This file
```

## WASI API Coverage

### File System
- `path_open` - Open files and directories
- `fd_read` - Read from file descriptors
- `fd_write` - Write to file descriptors
- `fd_close` - Close file descriptors
- `fd_readdir` - Read directory entries
- `fd_prestat_get` / `fd_prestat_dir_name` - Preopened directories
- `path_create_directory` - Create directories
- `path_remove_directory` - Remove directories
- `path_unlink_file` - Remove files
- `path_rename` - Rename files

### Standard I/O
- `fd_write` to stdout (fd 1)
- `fd_write` to stderr (fd 2)
- `fd_read` from stdin (fd 0)

### Environment
- `environ_get` / `environ_sizes_get` - Environment variables
- `args_get` / `args_sizes_get` - Command-line arguments

### Clock
- `clock_time_get` - Get current time
- `clock_res_get` - Get clock resolution

### Random
- `random_get` - Generate random bytes

### Process
- `proc_exit` - Exit with status code
- `proc_raise` - Raise signal

## Test Format

WASI tests are written in WAT format and compiled to WASM. Each test should:

1. Use WASI imports from the `wasi_snapshot_preview1` module
2. Export a `_start` function (WASI entry point)
3. Test specific WASI functionality
4. Exit with code 0 on success, non-zero on failure

Example:
```wat
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (func (export "_start")
    ;; Test logic here
    (call $proc_exit (i32.const 0))  ;; Exit with success
  )
)
```

## Running Tests

```bash
# Test with specific runtime
./run_wasi_tests.sh --runtime wasmtime

# Test specific category
./run_wasi_tests.sh --category filesystem

# Test all WASI-compatible runtimes
./run_wasi_tests.sh --all-runtimes
```

## Compatible Runtimes

- **Wasmtime** - Full WASI Preview 1 and Preview 2 support
- **Wasmer** - WASI Preview 1 support
- **wazero** - WASI Preview 1 support (Go)
- **Node.js** - WASI Preview 1 support (via WASI module)
- **WasmEdge** - WASI Preview 1 support with extensions

## WASI Versions

- **Preview 1 (snapshot_preview1)** - Current stable version
- **Preview 2** - Component Model based (in development)

Most tests target Preview 1 as it's the most widely implemented.
