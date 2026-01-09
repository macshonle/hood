# Hood Project Makefile
# Compatible with GNU Make 3.81+ and macOS

# Directories
WABT_DIR := external/wabt
WABT_BUILD_DIR := $(WABT_DIR)/build
TEST_DIR := test/wat

# Tools
CMAKE := cmake
WAT2WASM := $(WABT_BUILD_DIR)/wat2wasm
WASM_INTERP := $(WABT_BUILD_DIR)/wasm-interp

# Default target
.PHONY: all
all: build

# Initialize git submodules
.PHONY: init submodules
init: submodules

submodules:
	@echo "Initializing git submodules..."
	git submodule update --init --recursive

# Build wabt
.PHONY: build build-wabt
build: build-wabt

build-wabt: $(WABT_BUILD_DIR)/Makefile
	@echo "Building wabt..."
	$(CMAKE) --build $(WABT_BUILD_DIR)

$(WABT_BUILD_DIR)/Makefile: | submodules
	@echo "Configuring wabt with cmake..."
	mkdir -p $(WABT_BUILD_DIR)
	cd $(WABT_BUILD_DIR) && $(CMAKE) ..

# Verify tools are built
.PHONY: check-tools
check-tools:
	@test -x $(WAT2WASM) || (echo "Error: wat2wasm not found. Run 'make build' first." && exit 1)
	@test -x $(WASM_INTERP) || (echo "Error: wasm-interp not found. Run 'make build' first." && exit 1)
	@echo "Tools verified: wat2wasm and wasm-interp are available"

# Run tests
.PHONY: test
test: check-tools
	@echo "Running WebAssembly text format tests..."
	cd $(TEST_DIR) && ./run_tests.sh

# Run tests for a specific directory or file
# Usage: make test-path PATH=core/numeric
.PHONY: test-path
test-path: check-tools
	@test -n "$(PATH)" || (echo "Usage: make test-path PATH=<path>" && exit 1)
	cd $(TEST_DIR) && ./run_tests.sh $(PATH)

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning wabt build directory..."
	rm -rf $(WABT_BUILD_DIR)
	@echo "Cleaning generated .wasm files..."
	find $(TEST_DIR) -name "*.wasm" -type f -delete 2>/dev/null || true

# Clean everything including submodule state
.PHONY: distclean
distclean: clean
	@echo "Deinitializing submodules..."
	git submodule deinit -f $(WABT_DIR) 2>/dev/null || true

# Show tool versions
.PHONY: info
info:
	@echo "=== Hood Project Info ==="
	@echo "Make version: $(MAKE_VERSION)"
	@echo "Shell: $(SHELL)"
	@echo ""
	@echo "=== Tool Paths ==="
	@echo "wat2wasm: $(WAT2WASM)"
	@echo "wasm-interp: $(WASM_INTERP)"
	@echo ""
	@echo "=== Tool Status ==="
	@test -x $(WAT2WASM) && echo "wat2wasm: FOUND" || echo "wat2wasm: NOT BUILT"
	@test -x $(WASM_INTERP) && echo "wasm-interp: FOUND" || echo "wasm-interp: NOT BUILT"
	@echo ""
	@echo "=== External Tools ==="
	@which cmake >/dev/null 2>&1 && cmake --version | head -1 || echo "cmake: NOT INSTALLED"

# Help
.PHONY: help
help:
	@echo "Hood Project Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build everything (default)"
	@echo "  init         Initialize git submodules"
	@echo "  build        Build wabt tools"
	@echo "  test         Run all conformance tests"
	@echo "  test-path    Run tests for specific path (PATH=<path>)"
	@echo "  clean        Remove build artifacts"
	@echo "  distclean    Remove build artifacts and reset submodules"
	@echo "  info         Show project and tool information"
	@echo "  help         Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make init build test"
	@echo "  make test-path PATH=core/numeric"
