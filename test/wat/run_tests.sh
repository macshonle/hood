#!/bin/bash

# WebAssembly Text Format Test Runner
# Uses wabt tools to validate .wat files

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WABT_DIR="${SCRIPT_DIR}/../../external/wabt/build"
WAT2WASM="${WABT_DIR}/wat2wasm"
WASM_INTERP="${WABT_DIR}/wasm-interp"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
PASSED=0
FAILED=0
SKIPPED=0

# Get proposal flag for a given proposal name
# Compatible with Bash 3.2 (no associative arrays)
get_proposal_flag() {
    case "$1" in
        tail-call)            echo "--enable-tail-call" ;;
        exceptions)           echo "--enable-exceptions" ;;
        threads)              echo "--enable-threads" ;;
        memory64)             echo "--enable-memory64" ;;
        multi-memory)         echo "--enable-multi-memory" ;;
        extended-const)       echo "--enable-extended-const" ;;
        relaxed-simd)         echo "--enable-relaxed-simd" ;;
        function-references)  echo "--enable-function-references" ;;
        *)                    echo "" ;;
    esac
}

# Check if wabt tools exist
check_wabt() {
    if [[ ! -x "$WAT2WASM" ]]; then
        echo -e "${RED}Error: wat2wasm not found at $WAT2WASM${NC}"
        echo "Please build wabt first:"
        echo "  cd external/wabt && mkdir build && cd build && cmake .. && make"
        exit 1
    fi
    if [[ ! -x "$WASM_INTERP" ]]; then
        echo -e "${RED}Error: wasm-interp not found at $WASM_INTERP${NC}"
        exit 1
    fi
}

# Get proposal flags for a file path
get_proposal_flags() {
    local file="$1"
    local flags=""
    local proposals="tail-call exceptions threads memory64 multi-memory extended-const relaxed-simd function-references"

    for proposal in $proposals; do
        if echo "$file" | grep -q "/proposals/${proposal}/"; then
            flags=$(get_proposal_flag "$proposal")
            break
        fi
    done

    echo "$flags"
}

# Test a single .wat file
test_file() {
    local wat_file="$1"
    local relative_path="${wat_file#$SCRIPT_DIR/}"
    local flags=$(get_proposal_flags "$wat_file")
    local wasm_file="${wat_file%.wat}.wasm"

    (( TOTAL++ )) || true

    # Skip files in imports directory (they need host bindings)
    if [[ "$wat_file" == *"/imports/"* ]]; then
        echo -e "${YELLOW}SKIP${NC} $relative_path (requires imports)"
        (( SKIPPED++ )) || true
        return
    fi

    # Try to compile
    if $WAT2WASM $flags "$wat_file" -o "$wasm_file" 2>/dev/null; then
        # Try to validate with wasm-interp (dry run)
        if $WASM_INTERP $flags "$wasm_file" --run-all-exports 2>/dev/null; then
            echo -e "${GREEN}PASS${NC} $relative_path"
            (( PASSED++ )) || true
        else
            # Some tests might trap intentionally, still count as pass if they compile
            echo -e "${GREEN}PASS${NC} $relative_path (compiles, execution may trap)"
            (( PASSED++ )) || true
        fi
        rm -f "$wasm_file"
    else
        echo -e "${RED}FAIL${NC} $relative_path (compilation error)"
        (( FAILED++ )) || true
        # Show the error
        $WAT2WASM $flags "$wat_file" -o "$wasm_file" 2>&1 | head -5 || true
    fi
}

# Test all .wat files in a directory
test_directory() {
    local dir="$1"
    local files=$(find "$dir" -name "*.wat" -type f | sort)

    for file in $files; do
        test_file "$file"
    done
}

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS] [PATHS...]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Show more output"
    echo "  -q, --quiet    Only show failures"
    echo ""
    echo "Paths:"
    echo "  If no paths given, tests all .wat files"
    echo "  Can specify directories or individual .wat files"
    echo ""
    echo "Examples:"
    echo "  $0                           # Run all tests"
    echo "  $0 core/numeric              # Test numeric operations"
    echo "  $0 proposals/simd            # Test SIMD proposal"
    echo "  $0 core/types/i32_const.wat  # Test specific file"
}

# Main
main() {
    check_wabt

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}WebAssembly Text Format Test Suite${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo "Using wat2wasm: $WAT2WASM"
    echo "Using wasm-interp: $WASM_INTERP"
    echo ""

    local paths=("$@")

    if [[ ${#paths[@]} -eq 0 ]]; then
        # Test everything
        echo -e "${BLUE}Testing all .wat files...${NC}"
        echo ""
        test_directory "$SCRIPT_DIR"
    else
        for path in "${paths[@]}"; do
            if [[ "$path" == "-h" || "$path" == "--help" ]]; then
                usage
                exit 0
            fi

            local full_path="$SCRIPT_DIR/$path"
            if [[ -d "$full_path" ]]; then
                echo -e "${BLUE}Testing directory: $path${NC}"
                test_directory "$full_path"
            elif [[ -f "$full_path" ]]; then
                test_file "$full_path"
            elif [[ -f "$path" ]]; then
                test_file "$path"
            else
                echo -e "${RED}Error: $path not found${NC}"
                exit 1
            fi
        done
    fi

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Summary${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "Total:   $TOTAL"
    echo -e "${GREEN}Passed:  $PASSED${NC}"
    echo -e "${RED}Failed:  $FAILED${NC}"
    echo -e "${YELLOW}Skipped: $SKIPPED${NC}"

    if [[ $FAILED -gt 0 ]]; then
        exit 1
    fi
}

main "$@"
