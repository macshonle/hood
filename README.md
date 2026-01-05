# hood
The Hood programming system

## Dependencies

This project uses [WebAssembly Binary Toolkit (WABT)](https://github.com/WebAssembly/wabt) as a git submodule.

### Cloning with Submodules

When cloning this repository, use the `--recursive` flag to automatically initialize and update the submodule:

```bash
git clone --recursive https://github.com/macshonle/hood.git
```

### Initializing Submodules in Existing Clone

If you've already cloned the repository without the `--recursive` flag, initialize the submodule with:

```bash
git submodule update --init --recursive
```

### Updating Submodules

To update the wabt submodule to the latest version:

```bash
git submodule update --remote external/wabt
```

### WABT Location

The WABT toolkit is located at `external/wabt/` within the project directory.
