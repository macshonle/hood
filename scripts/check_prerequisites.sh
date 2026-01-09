#!/bin/bash

# Prerequisites Checker for Hood Test Suite
# Verifies system has necessary tools before running setup

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Track status
REQUIRED_MISSING=0
OPTIONAL_MISSING=0

# Detect OS for package manager suggestions
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        *)          echo "unknown";;
    esac
}

get_install_hint() {
    local package=$1
    local os=$(detect_os)

    case "$os" in
        macos)
            case "$package" in
                cmake)        echo "brew install cmake";;
                build-essential) echo "xcode-select --install";;
                make)         echo "xcode-select --install";;
                git)          echo "xcode-select --install  OR  brew install git";;
                curl)         echo "curl is pre-installed on macOS";;
                tar)          echo "tar is pre-installed on macOS";;
                *)            echo "brew install $package";;
            esac
            ;;
        linux)
            echo "sudo apt install $package  (Debian/Ubuntu)"
            ;;
        *)
            echo "Install $package using your package manager"
            ;;
    esac
}

print_header "Hood Test Suite - Prerequisites Check"
echo ""

# Detect architecture
ARCH=$(uname -m)
OS=$(uname -s)

echo "System Information:"
echo "  OS: $OS"
echo "  Architecture: $ARCH"
echo ""

if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    check_warn "Unsupported architecture: $ARCH (x86_64 or aarch64 recommended)"
fi

print_header "Required Tools"
echo ""

# Check CMake
if command -v cmake &> /dev/null; then
    VERSION=$(cmake --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    MAJOR=$(echo "$VERSION" | cut -d. -f1)
    MINOR=$(echo "$VERSION" | cut -d. -f2)

    if [[ $MAJOR -gt 3 || ($MAJOR -eq 3 && $MINOR -ge 12) ]]; then
        check_pass "CMake $VERSION (need 3.12+)"
    else
        check_fail "CMake $VERSION is too old (need 3.12+)"
        REQUIRED_MISSING=1
    fi
else
    check_fail "CMake not found (required for WABT)"
    echo "         Install: $(get_install_hint cmake)"
    REQUIRED_MISSING=1
fi

# Check GCC/Clang
if command -v gcc &> /dev/null; then
    VERSION=$(gcc --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "GCC $VERSION"
elif command -v clang &> /dev/null; then
    VERSION=$(clang --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "Clang $VERSION"
else
    check_fail "C++ compiler not found (gcc or clang required)"
    echo "         Install: $(get_install_hint build-essential)"
    REQUIRED_MISSING=1
fi

# Check make
if command -v make &> /dev/null; then
    VERSION=$(make --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+' | head -1)
    check_pass "Make $VERSION"
else
    check_fail "Make not found"
    echo "         Install: $(get_install_hint make)"
    REQUIRED_MISSING=1
fi

# Check git
if command -v git &> /dev/null; then
    VERSION=$(git --version 2>&1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "Git $VERSION"
else
    check_fail "Git not found"
    echo "         Install: $(get_install_hint git)"
    REQUIRED_MISSING=1
fi

# Check curl or wget
if command -v curl &> /dev/null; then
    VERSION=$(curl --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "curl $VERSION"
elif command -v wget &> /dev/null; then
    VERSION=$(wget --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "wget $VERSION"
else
    check_fail "curl or wget not found"
    echo "         Install: $(get_install_hint curl)"
    REQUIRED_MISSING=1
fi

# Check tar
if command -v tar &> /dev/null; then
    check_pass "tar (for extracting archives)"
else
    check_fail "tar not found"
    echo "         Install: $(get_install_hint tar)"
    REQUIRED_MISSING=1
fi

echo ""
print_header "Optional Tools (for specific runtimes)"
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    FULL_VERSION=$(node --version 2>&1 | cut -c2-)
    MAJOR_VERSION=$(echo "$FULL_VERSION" | cut -d. -f1)
    if [[ $MAJOR_VERSION -ge 18 ]]; then
        check_pass "Node.js v$FULL_VERSION (need 18+)"
    else
        check_warn "Node.js v$FULL_VERSION is too old (need 18+ for WASI/WasmGC)"
        echo "         Upgrade: https://nodejs.org/"
        OPTIONAL_MISSING=1
    fi
else
    check_warn "Node.js not found (optional: for Node.js runtime tests)"
    echo "         Install: https://nodejs.org/"
    OPTIONAL_MISSING=1
fi

# Check Go
if command -v go &> /dev/null; then
    VERSION=$(go version 2>&1 | grep -Eo 'go[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    check_pass "Go $VERSION (for wazero runtime)"
else
    check_warn "Go not found (optional: only needed for wazero runtime)"
    echo "         Install: https://golang.org/doc/install"
    OPTIONAL_MISSING=1
fi

# Check Python3
if command -v python3 &> /dev/null; then
    VERSION=$(python3 --version 2>&1 | grep -Eo '[0-9]+\.[0-9]+' | head -1)
    check_pass "Python $VERSION (may be needed for some build scripts)"
else
    check_warn "Python3 not found (usually not needed, but some builds may require it)"
fi

echo ""
print_header "Project Status"
echo ""

# Check WABT submodule
if [[ -d "external/wabt/.git" || -f "external/wabt/CMakeLists.txt" ]]; then
    check_pass "WABT submodule initialized"

    if [[ -x "external/wabt/build/wat2wasm" ]]; then
        check_pass "WABT already built"
    else
        check_info "WABT needs to be built (will be done by setup script)"
    fi
else
    check_warn "WABT submodule not initialized"
    echo "         Run: git submodule update --init --recursive"
fi

# Check for bin directory
if [[ -d "bin" ]]; then
    check_pass "bin/ directory exists"

    # Check for installed runtimes
    INSTALLED=0
    for runtime in wasmtime wasmer wazero wasmedge; do
        if [[ -x "bin/$runtime" ]]; then
            check_pass "$runtime installed"
            INSTALLED=$((INSTALLED + 1))
        fi
    done

    if [[ $INSTALLED -eq 0 ]]; then
        check_info "No runtimes installed yet (run setup script)"
    fi
else
    check_info "bin/ directory will be created by setup script"
fi

# Check test files
TEST_COUNT=$(find test -name "*.wat" -type f 2>/dev/null | wc -l)
if [[ $TEST_COUNT -gt 0 ]]; then
    check_pass "Found $TEST_COUNT test files"
else
    check_warn "No test files found"
fi

echo ""
print_header "Summary"
echo ""

if [[ $REQUIRED_MISSING -eq 0 && $OPTIONAL_MISSING -eq 0 ]]; then
    check_pass "All prerequisites met! Ready to run setup script."
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./scripts/setup_runtimes.sh"
    echo "  2. Test: ./test/run_conformance.sh --all-runtimes"
    exit 0
elif [[ $REQUIRED_MISSING -eq 0 ]]; then
    check_pass "All required prerequisites met!"
    check_warn "Some optional tools are missing"
    echo ""
    echo "You can proceed with setup, but some runtimes may not be available."
    echo ""
    echo "Next steps:"
    echo "  1. (Optional) Install missing tools for more runtime coverage"
    echo "  2. Run: ./scripts/setup_runtimes.sh"
    echo "  3. Test: ./test/run_conformance.sh --all-runtimes"
    exit 0
else
    check_fail "Missing required prerequisites"
    echo ""
    echo "Please install the missing required tools before proceeding."
    echo ""
    if [[ "$(detect_os)" == "macos" ]]; then
        echo "Quick install (macOS):"
        echo "  xcode-select --install    # For git, make, compiler"
        echo "  brew install cmake        # If Homebrew is installed"
    else
        echo "Quick install (Ubuntu/Debian):"
        echo "  sudo apt update"
        echo "  sudo apt install -y cmake build-essential git curl"
    fi
    echo ""
    echo "Then run this check again: ./scripts/check_prerequisites.sh"
    exit 1
fi
