#!/bin/bash

# WebAssembly Runtime Setup Script
# Installs and configures WASM runtimes for conformance testing

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BIN_DIR="${PROJECT_ROOT}/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create bin directory
mkdir -p "$BIN_DIR"

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=linux;;
        Darwin*)    OS=macos;;
        *)          OS=unknown;;
    esac
    echo "$OS"
}

# Detect architecture
detect_arch() {
    local machine=$(uname -m)
    case "$machine" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Setup WABT (from submodule)
setup_wabt() {
    print_header "Setting up WABT"

    local wabt_dir="${PROJECT_ROOT}/external/wabt"
    local wabt_build="${wabt_dir}/build"

    if [[ ! -d "$wabt_dir/.git" ]]; then
        print_info "Initializing WABT submodule..."
        cd "$PROJECT_ROOT"
        git submodule update --init --recursive
    fi

    if [[ -x "${wabt_build}/wat2wasm" && -x "${wabt_build}/wasm-interp" ]]; then
        print_success "WABT already built"
        return 0
    fi

    print_info "Building WABT..."
    cd "$wabt_dir"
    mkdir -p build
    cd build

    if command -v cmake &> /dev/null; then
        cmake .. -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)
        print_success "WABT built successfully"
    else
        print_error "cmake not found. Please install cmake to build WABT."
        return 1
    fi
}

# Setup Wasmtime
setup_wasmtime() {
    print_header "Setting up Wasmtime"

    if [[ -x "${BIN_DIR}/wasmtime" ]]; then
        print_success "Wasmtime already installed"
        return 0
    fi

    local os=$(detect_os)
    local arch=$(detect_arch)
    local version="v27.0.0"

    # Wasmtime uses different naming: x86_64 stays x86_64, aarch64 stays aarch64
    local archive_name="wasmtime-${version}-${arch}-${os}"
    local url="https://github.com/bytecodealliance/wasmtime/releases/download/${version}/${archive_name}.tar.xz"

    print_info "Downloading Wasmtime ${version} for ${os}-${arch}..."

    cd /tmp
    if command -v curl &> /dev/null; then
        if ! curl -L "$url" -o wasmtime.tar.xz 2>&1; then
            print_error "Failed to download Wasmtime for ${arch}. URL: $url"
            print_info "Wasmtime may not have ARM64 builds for all versions."
            return 1
        fi
    elif command -v wget &> /dev/null; then
        if ! wget "$url" -O wasmtime.tar.xz 2>&1; then
            print_error "Failed to download Wasmtime for ${arch}. URL: $url"
            return 1
        fi
    else
        print_error "Neither curl nor wget found. Please install one."
        return 1
    fi

    print_info "Extracting Wasmtime..."
    tar -xf wasmtime.tar.xz

    print_info "Installing Wasmtime to ${BIN_DIR}..."
    cp "${archive_name}/wasmtime" "$BIN_DIR/"
    chmod +x "${BIN_DIR}/wasmtime"

    rm -rf wasmtime.tar.xz "$archive_name"

    print_success "Wasmtime installed successfully"
}

# Setup Wasmer
setup_wasmer() {
    print_header "Setting up Wasmer"

    if command -v wasmer &> /dev/null; then
        print_success "Wasmer already installed (system-wide)"
        # Create symlink in bin dir
        ln -sf "$(command -v wasmer)" "${BIN_DIR}/wasmer" 2>/dev/null || true
        return 0
    fi

    if [[ -x "${BIN_DIR}/wasmer" ]]; then
        print_success "Wasmer already installed"
        return 0
    fi

    local arch=$(detect_arch)
    print_info "Installing Wasmer for ${arch}..."

    # Use Wasmer's official installer (supports ARM64 automatically)
    if command -v curl &> /dev/null; then
        if curl https://get.wasmer.io -sSfL | sh -s -- --no-modify-path; then
            # Copy to bin dir
            if [[ -f "$HOME/.wasmer/bin/wasmer" ]]; then
                cp "$HOME/.wasmer/bin/wasmer" "$BIN_DIR/"
                chmod +x "${BIN_DIR}/wasmer"
                print_success "Wasmer installed successfully"
            else
                print_error "Wasmer binary not found after installation"
                return 1
            fi
        else
            print_error "Wasmer installation script failed"
            return 1
        fi
    else
        print_error "curl not found. Please install curl."
        return 1
    fi
}

# Setup wazero
setup_wazero() {
    print_header "Setting up wazero"

    if ! command -v go &> /dev/null; then
        print_error "Go not found. Please install Go to use wazero."
        print_info "Visit: https://golang.org/doc/install"
        return 1
    fi

    if [[ -x "${BIN_DIR}/wazero" ]]; then
        print_success "wazero already installed"
        return 0
    fi

    print_info "Installing wazero..."
    go install github.com/tetratelabs/wazero/cmd/wazero@latest

    # Copy from GOPATH/bin to our bin dir
    local gobin="${GOBIN:-$(go env GOPATH)/bin}"
    if [[ -f "${gobin}/wazero" ]]; then
        cp "${gobin}/wazero" "$BIN_DIR/"
        chmod +x "${BIN_DIR}/wazero"
        print_success "wazero installed successfully"
    else
        print_error "wazero installation failed"
        return 1
    fi
}

# Check Node.js
check_nodejs() {
    print_header "Checking Node.js"

    if command -v node &> /dev/null; then
        local version=$(node --version)
        print_success "Node.js found: $version"

        # Create symlink for consistency
        ln -sf "$(command -v node)" "${BIN_DIR}/node" 2>/dev/null || true

        # Check version (need 18+)
        local major=$(echo "$version" | sed 's/v\([0-9]*\).*/\1/')
        if [[ $major -ge 18 ]]; then
            print_success "Node.js version is sufficient (18+)"
        else
            print_error "Node.js version is too old. Please upgrade to 18+"
        fi
    else
        print_error "Node.js not found"
        print_info "Install from: https://nodejs.org/"
        return 1
    fi
}

# Setup WasmEdge
setup_wasmedge() {
    print_header "Setting up WasmEdge"

    if command -v wasmedge &> /dev/null; then
        print_success "WasmEdge already installed (system-wide)"
        ln -sf "$(command -v wasmedge)" "${BIN_DIR}/wasmedge" 2>/dev/null || true
        return 0
    fi

    if [[ -x "${BIN_DIR}/wasmedge" ]]; then
        print_success "WasmEdge already installed"
        return 0
    fi

    local arch=$(detect_arch)
    print_info "Installing WasmEdge for ${arch}..."

    if command -v curl &> /dev/null; then
        # WasmEdge installer supports ARM64 automatically
        if curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p "$PROJECT_ROOT"; then
            if [[ -f "${PROJECT_ROOT}/bin/wasmedge" ]]; then
                chmod +x "${PROJECT_ROOT}/bin/wasmedge"
                print_success "WasmEdge installed successfully"
            else
                print_error "WasmEdge binary not found after installation"
                return 1
            fi
        else
            print_error "WasmEdge installation script failed"
            return 1
        fi
    else
        print_error "curl not found. Please install curl."
        return 1
    fi
}

# Main setup
main() {
    print_header "WebAssembly Runtime Setup"
    echo ""

    local os=$(detect_os)
    local arch=$(detect_arch)

    echo "Detected system: ${os}-${arch}"
    echo ""
    echo "This script will install WebAssembly runtimes for testing:"
    echo "  - WABT (core WASM tools)"
    echo "  - Wasmtime (WASI, WasmGC, Component Model)"
    echo "  - Wasmer (WASI, WASIX)"
    echo "  - wazero (Go-based, WASI)"
    echo "  - Node.js (check only)"
    echo "  - WasmEdge (optional)"
    echo ""

    if [[ "$arch" == "aarch64" ]]; then
        print_info "ARM64 architecture detected. All runtimes support this architecture."
        echo ""
    elif [[ "$arch" == "unknown" ]]; then
        print_error "Unknown architecture: $(uname -m)"
        print_error "This script supports x86_64 and aarch64/arm64 only."
        exit 1
    fi

    local install_all=false
    local runtimes=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                install_all=true
                shift
                ;;
            --wabt)
                runtimes+=("wabt")
                shift
                ;;
            --wasmtime)
                runtimes+=("wasmtime")
                shift
                ;;
            --wasmer)
                runtimes+=("wasmer")
                shift
                ;;
            --wazero)
                runtimes+=("wazero")
                shift
                ;;
            --nodejs)
                runtimes+=("nodejs")
                shift
                ;;
            --wasmedge)
                runtimes+=("wasmedge")
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --all          Install all runtimes"
                echo "  --wabt         Install WABT only"
                echo "  --wasmtime     Install Wasmtime only"
                echo "  --wasmer       Install Wasmer only"
                echo "  --wazero       Install wazero only"
                echo "  --nodejs       Check Node.js only"
                echo "  --wasmedge     Install WasmEdge only"
                echo "  --help, -h     Show this help"
                echo ""
                echo "If no options provided, installs core runtimes (WABT, Wasmtime, Wasmer)"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Default: install core runtimes
    if [[ $install_all == false && ${#runtimes[@]} -eq 0 ]]; then
        runtimes=("wabt" "wasmtime" "wasmer")
    fi

    # Install all if requested
    if [[ $install_all == true ]]; then
        runtimes=("wabt" "wasmtime" "wasmer" "wazero" "nodejs" "wasmedge")
    fi

    echo "Installing: ${runtimes[*]}"
    echo ""

    local failed=()

    for runtime in "${runtimes[@]}"; do
        case $runtime in
            wabt)
                setup_wabt || failed+=("wabt")
                ;;
            wasmtime)
                setup_wasmtime || failed+=("wasmtime")
                ;;
            wasmer)
                setup_wasmer || failed+=("wasmer")
                ;;
            wazero)
                setup_wazero || failed+=("wazero")
                ;;
            nodejs)
                check_nodejs || failed+=("nodejs")
                ;;
            wasmedge)
                setup_wasmedge || failed+=("wasmedge")
                ;;
        esac
        echo ""
    done

    # Summary
    print_header "Setup Summary"

    if [[ ${#failed[@]} -eq 0 ]]; then
        print_success "All runtimes set up successfully!"
    else
        print_error "Some runtimes failed to set up: ${failed[*]}"
        echo ""
        echo "You can still use the runtimes that installed successfully."
    fi

    echo ""
    echo "Runtime binaries are in: $BIN_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. Run tests: cd test/wat && ./run_tests.sh"
    echo "  2. Run WASI tests: ./run_wasi_tests.sh"
    echo "  3. Run multi-runtime tests: ./run_conformance.sh"
}

main "$@"
