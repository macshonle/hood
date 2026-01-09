#!/usr/bin/env bash

# Prerequisites Checker for Hood Project
# Verifies system has necessary tools installed
# Exit codes: 0 = all required present, 1 = missing required tools

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Track missing prerequisites
MISSING_REQUIRED=()
MISSING_OPTIONAL=()

check_command() {
  local cmd=$1
  local required=$2
  local description=$3
  local install_hint=$4

  if command -v "$cmd" &> /dev/null; then
    local version
    case "$cmd" in
      cmake)
        version=$(cmake --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        ;;
      go)
        version=$(go version 2>&1 | grep -Eo 'go[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        ;;
      node)
        version=$(node --version 2>&1)
        ;;
      gcc|clang)
        version=$(${cmd} --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
        ;;
      *)
        version=$($cmd --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1 || echo "unknown")
        ;;
    esac
    echo "[OK] $cmd $version"
    return 0
  else
    if [ "$required" = "required" ]; then
      echo "[MISSING] $cmd - $description"
      echo "          Install: $install_hint"
      MISSING_REQUIRED+=("$cmd")
    else
      echo "[MISSING] $cmd - $description (optional)"
      echo "          Install: $install_hint"
      MISSING_OPTIONAL+=("$cmd")
    fi
    return 1
  fi
}

check_cmake_version() {
  if ! command -v cmake &> /dev/null; then
    return 1
  fi
  local version
  version=$(cmake --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+' | head -1)
  local major minor
  major=$(echo "$version" | cut -d. -f1)
  minor=$(echo "$version" | cut -d. -f2)
  if [ "$major" -gt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -ge 12 ]; }; then
    return 0
  else
    echo "[ERROR] CMake version $version is too old (need 3.12+)"
    MISSING_REQUIRED+=("cmake-upgrade")
    return 1
  fi
}

check_node_version() {
  if ! command -v node &> /dev/null; then
    return 1
  fi
  local version
  version=$(node --version 2>&1 | sed 's/^v//')
  local major
  major=$(echo "$version" | cut -d. -f1)
  if [ "$major" -ge 18 ]; then
    return 0
  else
    echo "[WARNING] Node.js version $version is old (recommend 18+ for WASI tests)"
    return 0
  fi
}

check_cpp_compiler() {
  if command -v clang &> /dev/null; then
    local version
    version=$(clang --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    echo "[OK] clang $version"
    return 0
  elif command -v gcc &> /dev/null; then
    local version
    version=$(gcc --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    echo "[OK] gcc $version"
    return 0
  else
    echo "[MISSING] C++ compiler (gcc or clang) - required for building wabt"
    echo "          Install: xcode-select --install (macOS) or apt install build-essential (Linux)"
    MISSING_REQUIRED+=("c++ compiler")
    return 1
  fi
}

check_curl_or_wget() {
  if command -v curl &> /dev/null; then
    local version
    version=$(curl --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    echo "[OK] curl $version"
    return 0
  elif command -v wget &> /dev/null; then
    local version
    version=$(wget --version 2>&1 | head -1 | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1)
    echo "[OK] wget $version"
    return 0
  else
    echo "[MISSING] curl or wget - required for downloading runtimes"
    echo "          Install: brew install curl (macOS) or apt install curl (Linux)"
    MISSING_REQUIRED+=("curl")
    return 1
  fi
}

# Detect OS
detect_os() {
  case "$(uname -s)" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "macos" ;;
    *)       echo "unknown" ;;
  esac
}

# Main
echo "Hood Project - Prerequisites Check"
echo "==================================="
echo ""
echo "System: $(uname -s) $(uname -m)"
echo ""

echo "Required Tools:"
echo "---------------"

# CMake (required for wabt)
check_command "cmake" "required" "required for building wabt" "brew install cmake (macOS) or apt install cmake (Linux)"
check_cmake_version

# C++ compiler (required for wabt)
check_cpp_compiler

# Make (required for build)
check_command "make" "required" "required for build system" "xcode-select --install (macOS) or apt install build-essential (Linux)"

# Git (required for submodules)
check_command "git" "required" "required for submodules" "xcode-select --install (macOS) or apt install git (Linux)"

# curl or wget (required for downloading runtimes)
check_curl_or_wget

# tar (required for extracting archives)
check_command "tar" "required" "required for extracting archives" "pre-installed on most systems"

echo ""
echo "Optional Tools:"
echo "---------------"

# Go (optional, for wazero)
check_command "go" "optional" "needed for wazero runtime" "brew install go (macOS) or apt install golang (Linux)"

# Node.js (optional, for Node.js runtime tests)
if check_command "node" "optional" "needed for Node.js runtime tests" "brew install node (macOS) or apt install nodejs (Linux)"; then
  check_node_version
fi

echo ""
echo "==================================="

if [ ${#MISSING_REQUIRED[@]} -gt 0 ]; then
  echo "FAILED: Missing required tools: ${MISSING_REQUIRED[*]}"
  echo ""
  echo "Please install the missing tools and run this check again."
  exit 1
elif [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
  echo "OK: All required tools present (some optional tools missing)"
  echo ""
  echo "You can proceed with: make init build"
  echo "Some runtimes may not be available without optional tools."
  exit 0
else
  echo "OK: All prerequisites met"
  echo ""
  echo "Next steps:"
  echo "  make init              # Initialize submodules"
  echo "  make build             # Build wabt"
  echo "  make install-runtimes  # Install WASM runtimes"
  echo "  make test              # Run tests"
  exit 0
fi
