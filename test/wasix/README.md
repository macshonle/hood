# WASIX Test Suite

Tests for WASIX - Wasmer's extended WASI with additional POSIX-like capabilities.

## What is WASIX?

WASIX extends WASI Preview 1 with additional features that enable running more complex applications:

- **Networking**: TCP/UDP sockets, DNS resolution
- **Threading**: POSIX-like threads beyond basic atomics
- **Process Management**: fork, exec, waitpid
- **IPC**: Pipes, Unix domain sockets
- **Advanced I/O**: epoll, select, poll
- **More POSIX APIs**: Additional filesystem operations, signals

## Structure

```
test/wasix/
├── networking/        # Socket operations (TCP, UDP, DNS)
├── threading/         # Thread creation and management
├── ipc/               # Inter-process communication (pipes, signals)
├── advanced-fs/       # Extended filesystem operations
└── README.md          # This file
```

## WASIX API Extensions

### Networking
- `sock_open` - Create socket
- `sock_bind` - Bind socket to address
- `sock_listen` - Listen for connections
- `sock_accept` - Accept connection
- `sock_connect` - Connect to remote address
- `sock_send` / `sock_recv` - Send/receive data
- `resolve` - DNS resolution

### Threading
- `thread_spawn` - Create new thread
- `thread_exit` - Exit thread
- `thread_join` - Wait for thread completion

### Process Management
- `proc_fork` - Fork process
- `proc_exec` - Execute program
- `proc_waitpid` - Wait for child process

### IPC
- `pipe` - Create pipe
- `sock_open_unix` - Unix domain sockets

## Compatible Runtimes

Currently, WASIX is primarily supported by:
- **Wasmer** - Full WASIX support

Other runtimes may add WASIX support in the future.

## Running Tests

```bash
# Run WASIX tests with Wasmer
./run_wasix_tests.sh --runtime wasmer

# Test specific category
./run_wasix_tests.sh --category networking
```

## Note on Testing

Many WASIX features require runtime environment setup:
- Networking tests may require network access
- Threading tests require runtime threading support
- Process tests may have limitations in sandboxed environments

Tests are designed to gracefully handle unavailable features when possible.
