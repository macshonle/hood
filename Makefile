# Hood Project Makefile
# Compatible with GNU Make 3.81+ and macOS

# Directories
WABT_DIR := external/wabt
WASMTIME_DIR := external/wasmtime
WAZERO_DIR := external/wazero
WASMER_DIR := external/wasmer
WASMEDGE_DIR := external/wasmedge
TEST_DIR := test/wat

# Tools (paths after binary installation)
WAT2WASM := $(WABT_DIR)/bin/wat2wasm
WASM_INTERP := $(WABT_DIR)/bin/wasm-interp

# Runtime versions
WABT_VERSION := 1.0.39
WASMTIME_VERSION := v27.0.0
WASMER_VERSION := v6.1.0

# Detect OS and architecture
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
  OS := macos
else ifeq ($(UNAME_S),Linux)
  OS := linux
else
  OS := unknown
endif

ifeq ($(UNAME_M),x86_64)
  ARCH := x86_64
else ifeq ($(UNAME_M),amd64)
  ARCH := x86_64
else ifeq ($(UNAME_M),aarch64)
  ARCH := aarch64
else ifeq ($(UNAME_M),arm64)
  ARCH := aarch64
else
  ARCH := unknown
endif

# Default target
.PHONY: all
all: install-wabt

# Check prerequisites
.PHONY: check-prereqs
check-prereqs:
	@./scripts/check_prerequisites.sh

# Verify tools are installed
.PHONY: check-tools
check-tools:
	@test -x $(WAT2WASM) || (echo "Error: wat2wasm not found. Run 'make install-wabt' first." && exit 1)
	@test -x $(WASM_INTERP) || (echo "Error: wasm-interp not found. Run 'make install-wabt' first." && exit 1)
	@echo "Tools verified: wat2wasm and wasm-interp are available"

# =============================================================================
# Runtime Installation Targets
# =============================================================================

# Install all available runtimes
.PHONY: install-runtimes
install-runtimes: install-wabt install-wasmtime install-wazero install-wasmer install-wasmedge
	@echo ""
	@echo "Runtime installation complete."
	@echo "Run 'make info' to see installed runtimes."

# Install wabt (all platforms via direct download)
.PHONY: install-wabt
install-wabt:
	@if [ -x "$(WAT2WASM)" ]; then \
		echo "wabt already installed"; \
	else \
		echo "Installing wabt $(WABT_VERSION) for $(OS)-$(ARCH)..."; \
		mkdir -p $(WABT_DIR); \
		WABT_ARCH="$(if $(filter aarch64,$(ARCH)),arm64,x64)"; \
		ARCHIVE="wabt-$(WABT_VERSION)-$(OS)-$${WABT_ARCH}"; \
		echo "Downloading $${ARCHIVE}.tar.gz..."; \
		curl -L "https://github.com/WebAssembly/wabt/releases/download/$(WABT_VERSION)/$${ARCHIVE}.tar.gz" -o /tmp/wabt.tar.gz; \
		tar -xzf /tmp/wabt.tar.gz -C /tmp; \
		cp -r /tmp/wabt-$(WABT_VERSION)/* $(WABT_DIR)/; \
		chmod +x $(WABT_DIR)/bin/*; \
		rm -rf /tmp/wabt.tar.gz /tmp/wabt-$(WABT_VERSION); \
		echo "wabt installed to $(WABT_DIR)/"; \
	fi

# Install wasmtime (all platforms)
.PHONY: install-wasmtime
install-wasmtime:
	@if [ -x "$(WASMTIME_DIR)/wasmtime" ]; then \
		echo "wasmtime already installed"; \
	else \
		echo "Installing wasmtime $(WASMTIME_VERSION) for $(OS)-$(ARCH)..."; \
		mkdir -p $(WASMTIME_DIR); \
		ARCHIVE="wasmtime-$(WASMTIME_VERSION)-$(ARCH)-$(OS)"; \
		curl -L "https://github.com/bytecodealliance/wasmtime/releases/download/$(WASMTIME_VERSION)/$${ARCHIVE}.tar.xz" -o /tmp/wasmtime.tar.xz; \
		tar -xf /tmp/wasmtime.tar.xz -C /tmp; \
		cp "/tmp/$${ARCHIVE}/wasmtime" $(WASMTIME_DIR)/; \
		chmod +x $(WASMTIME_DIR)/wasmtime; \
		rm -rf /tmp/wasmtime.tar.xz "/tmp/$${ARCHIVE}"; \
		echo "wasmtime installed to $(WASMTIME_DIR)/"; \
	fi

# Install wazero (all platforms, requires Go)
.PHONY: install-wazero
install-wazero:
	@if [ -x "$(WAZERO_DIR)/bin/wazero" ]; then \
		echo "wazero already installed"; \
	elif ! command -v go >/dev/null 2>&1; then \
		echo "[INFO] wazero requires Go - skipping (install Go to enable)"; \
	else \
		echo "Installing wazero..."; \
		mkdir -p $(WAZERO_DIR)/bin; \
		GOBIN="$(shell pwd)/$(WAZERO_DIR)/bin" go install github.com/tetratelabs/wazero/cmd/wazero@latest; \
		echo "wazero installed to $(WAZERO_DIR)/bin/"; \
	fi

# Install wasmer (all platforms via direct download)
.PHONY: install-wasmer
install-wasmer:
	@if [ -x "$(WASMER_DIR)/bin/wasmer" ]; then \
		echo "wasmer already installed"; \
	else \
		echo "Installing wasmer $(WASMER_VERSION) for $(OS)-$(ARCH)..."; \
		mkdir -p $(WASMER_DIR)/bin; \
		WASMER_OS="$(if $(filter macos,$(OS)),darwin,linux)"; \
		WASMER_ARCH="$(if $(filter aarch64,$(ARCH)),arm64,amd64)"; \
		if [ "$(OS)" = "linux" ] && [ "$(ARCH)" = "aarch64" ]; then WASMER_ARCH="aarch64"; fi; \
		ARCHIVE="wasmer-$${WASMER_OS}-$${WASMER_ARCH}"; \
		echo "Downloading $${ARCHIVE}.tar.gz..."; \
		curl -L "https://github.com/wasmerio/wasmer/releases/download/$(WASMER_VERSION)/$${ARCHIVE}.tar.gz" -o /tmp/wasmer.tar.gz; \
		tar -xzf /tmp/wasmer.tar.gz -C /tmp; \
		cp /tmp/bin/wasmer $(WASMER_DIR)/bin/; \
		chmod +x $(WASMER_DIR)/bin/wasmer; \
		rm -rf /tmp/wasmer.tar.gz /tmp/bin /tmp/lib /tmp/include /tmp/LICENSE /tmp/ATTRIBUTIONS; \
		echo "wasmer installed to $(WASMER_DIR)/bin/"; \
	fi

# Install wasmedge (Linux only)
.PHONY: install-wasmedge
install-wasmedge:
ifeq ($(OS),linux)
	@if [ -x "$(WASMEDGE_DIR)/bin/wasmedge" ]; then \
		echo "wasmedge already installed"; \
	else \
		echo "Installing wasmedge for $(OS)-$(ARCH)..."; \
		curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p "$(shell pwd)/$(WASMEDGE_DIR)"; \
		echo "wasmedge installed to $(WASMEDGE_DIR)/"; \
	fi
else
	@echo "[INFO] wasmedge: Linux only (not available on macOS)"
endif

# =============================================================================
# Clean Targets
# =============================================================================

# Clean wabt
.PHONY: clean-wabt
clean-wabt:
	@echo "Cleaning wabt..."
	rm -rf $(WABT_DIR)

# Clean wasmtime
.PHONY: clean-wasmtime
clean-wasmtime:
	@echo "Cleaning wasmtime..."
	rm -rf $(WASMTIME_DIR)

# Clean wazero
.PHONY: clean-wazero
clean-wazero:
	@echo "Cleaning wazero..."
	rm -rf $(WAZERO_DIR)

# Clean wasmer
.PHONY: clean-wasmer
clean-wasmer:
	@echo "Cleaning wasmer..."
	rm -rf $(WASMER_DIR)

# Clean wasmedge
.PHONY: clean-wasmedge
clean-wasmedge:
	@echo "Cleaning wasmedge..."
	rm -rf $(WASMEDGE_DIR)

# Clean all runtimes (including wabt)
.PHONY: clean-runtimes
clean-runtimes: clean-wabt clean-wasmtime clean-wazero clean-wasmer clean-wasmedge
	@echo "All runtime installations cleaned."

# Clean generated .wasm files only
.PHONY: clean
clean:
	@echo "Cleaning generated .wasm files..."
	find $(TEST_DIR) -name "*.wasm" -type f -delete 2>/dev/null || true
	find test -name "*.wasm" -type f -delete 2>/dev/null || true

# Clean everything
.PHONY: distclean
distclean: clean clean-runtimes
	@echo "All cleaned."

# =============================================================================
# Test Targets
# =============================================================================

# Run tests
.PHONY: test
test: check-tools
	@echo "Running WebAssembly text format tests..."
	cd $(TEST_DIR) && ./run_tests.sh

# Run conformance tests with all available runtimes
.PHONY: test-conformance
test-conformance: check-tools
	@echo "Running multi-runtime conformance tests..."
	./test/run_conformance.sh

# Run tests for a specific directory or file
# Usage: make test-path PATH=core/numeric
.PHONY: test-path
test-path: check-tools
	@test -n "$(PATH)" || (echo "Usage: make test-path PATH=<path>" && exit 1)
	cd $(TEST_DIR) && ./run_tests.sh $(PATH)

# =============================================================================
# Info and Help
# =============================================================================

# Show tool versions and status
.PHONY: info
info:
	@echo "=== Hood Project Info ==="
	@echo "Make version: $(MAKE_VERSION)"
	@echo "Platform: $(OS)-$(ARCH)"
	@echo ""
	@echo "=== Runtimes ==="
	@test -x $(WAT2WASM) && echo "wabt: $(WABT_DIR)/ (wat2wasm, wasm-interp)" || echo "wabt: not installed"
	@test -x $(WASMTIME_DIR)/wasmtime && echo "wasmtime: $(WASMTIME_DIR)/wasmtime" || echo "wasmtime: not installed"
	@test -x $(WAZERO_DIR)/bin/wazero && echo "wazero: $(WAZERO_DIR)/bin/wazero" || echo "wazero: not installed"
	@test -x $(WASMER_DIR)/bin/wasmer && echo "wasmer: $(WASMER_DIR)/bin/wasmer" || echo "wasmer: not installed"
	@test -x $(WASMEDGE_DIR)/bin/wasmedge && echo "wasmedge: $(WASMEDGE_DIR)/bin/wasmedge" || echo "wasmedge: not installed (Linux only)"
	@command -v node >/dev/null 2>&1 && echo "node: $$(which node)" || echo "node: not installed"
	@echo ""
	@echo "=== System Tools ==="
	@which go >/dev/null 2>&1 && go version || echo "go: NOT INSTALLED (optional, for wazero)"

# Help
.PHONY: help
help:
	@echo "Hood Project Makefile"
	@echo ""
	@echo "Setup:"
	@echo "  check-prereqs     Check system prerequisites"
	@echo "  install-runtimes  Install all runtimes (wabt, wasmtime, wazero, wasmer)"
	@echo ""
	@echo "Individual Runtime Installation:"
	@echo "  install-wabt      Install wabt (wat2wasm, wasm-interp)"
	@echo "  install-wasmtime  Install wasmtime"
	@echo "  install-wazero    Install wazero (requires Go)"
	@echo "  install-wasmer    Install wasmer"
	@echo "  install-wasmedge  Install wasmedge (Linux only)"
	@echo ""
	@echo "Testing:"
	@echo "  test              Run WAT format tests with wabt"
	@echo "  test-conformance  Run multi-runtime conformance tests"
	@echo "  test-path         Run tests for specific path (PATH=<path>)"
	@echo ""
	@echo "Cleaning:"
	@echo "  clean             Remove generated .wasm files"
	@echo "  clean-runtimes    Remove all installed runtimes"
	@echo "  distclean         Remove everything (runtimes + .wasm files)"
	@echo ""
	@echo "Info:"
	@echo "  info              Show installed runtimes"
	@echo "  help              Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make install-runtimes test"
	@echo "  make test-path PATH=core/numeric"
