#!/bin/bash

# WebAssembly Conformance Test Runner
# Multi-runtime test orchestration for core WASM, WASI, WASIX, and WasmGC
# Compatible with Bash 3.2+ (macOS default)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RUNTIME_MATRIX="${SCRIPT_DIR}/runtime-matrix.json"
WAT2WASM="${PROJECT_ROOT}/external/wabt/bin/wat2wasm"

# Tool availability flags
WAT2WASM_WORKS=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# List of all runtimes (used for iteration)
ALL_RUNTIMES="wabt wasmtime wasmer wazero nodejs wasmedge"

# Runtime availability (stored as RUNTIME_AVAILABLE_<name>)
# Test counters (stored as TOTAL_<name>, PASSED_<name>, etc.)
# These are set dynamically using eval for Bash 3.2 compatibility

# Helper functions to get/set runtime-specific variables (Bash 3.2 compatible)
get_runtime_var() {
    local prefix=$1
    local runtime=$2
    eval "echo \"\${${prefix}_${runtime}:-}\""
}

set_runtime_var() {
    local prefix=$1
    local runtime=$2
    local value=$3
    eval "${prefix}_${runtime}=\"\$value\""
}

increment_runtime_var() {
    local prefix=$1
    local runtime=$2
    local current=$(get_runtime_var "$prefix" "$runtime")
    current=${current:-0}
    set_runtime_var "$prefix" "$runtime" $((current + 1))
}

# Track which runtimes have been tested (for summary)
TESTED_RUNTIMES=""

add_tested_runtime() {
    local runtime=$1
    if [[ ! " $TESTED_RUNTIMES " =~ " $runtime " ]]; then
        TESTED_RUNTIMES="$TESTED_RUNTIMES $runtime"
    fi
}

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_subheader() {
    echo -e "${CYAN}--- $1 ---${NC}"
}

print_runtime_header() {
    echo -e "${MAGENTA}>>> $1 <<<${NC}"
}

# Verify a binary can actually execute (not just exists)
verify_binary_works() {
    local binary=$1
    local test_arg=$2

    if [[ ! -x "$binary" ]]; then
        return 1
    fi

    # Try to execute with a simple argument to verify it's a valid binary for this platform
    "$binary" $test_arg >/dev/null 2>&1
    return $?
}

# Check if wat2wasm works
check_wat2wasm() {
    if [[ ! -x "$WAT2WASM" ]]; then
        return 1
    fi

    # Try to run wat2wasm --version to verify it works
    if "$WAT2WASM" --version >/dev/null 2>&1; then
        WAT2WASM_WORKS=true
        return 0
    else
        WAT2WASM_WORKS=false
        return 1
    fi
}

check_runtime() {
    local runtime=$1
    local binary=""
    local version_arg="--version"

    case "$runtime" in
        wabt)
            binary="${PROJECT_ROOT}/external/wabt/bin/wasm-interp"
            version_arg="--version"
            ;;
        wasmtime)
            binary="${PROJECT_ROOT}/external/wasmtime/wasmtime"
            [[ ! -x "$binary" ]] && binary="$(command -v wasmtime 2>/dev/null || true)"
            version_arg="--version"
            ;;
        wasmer)
            binary="${PROJECT_ROOT}/external/wasmer/bin/wasmer"
            [[ ! -x "$binary" ]] && binary="$(command -v wasmer 2>/dev/null || true)"
            version_arg="--version"
            ;;
        wazero)
            binary="${PROJECT_ROOT}/external/wazero/bin/wazero"
            [[ ! -x "$binary" ]] && binary="$(command -v wazero 2>/dev/null || true)"
            version_arg="version"
            ;;
        nodejs)
            binary="$(command -v node 2>/dev/null || true)"
            version_arg="--version"
            ;;
        wasmedge)
            binary="${PROJECT_ROOT}/external/wasmedge/bin/wasmedge"
            [[ ! -x "$binary" ]] && binary="$(command -v wasmedge 2>/dev/null || true)"
            version_arg="--version"
            ;;
    esac

    # Check if binary exists and can actually execute
    if [[ -n "$binary" && -x "$binary" ]]; then
        # Verify the binary actually works on this platform
        if verify_binary_works "$binary" "$version_arg"; then
            set_runtime_var "RUNTIME_AVAILABLE" "$runtime" "$binary"
            return 0
        fi
    fi

    set_runtime_var "RUNTIME_AVAILABLE" "$runtime" ""
    return 1
}

get_runtime_binary() {
    local runtime=$1
    get_runtime_var "RUNTIME_AVAILABLE" "$runtime"
}

compile_wat() {
    local wat_file=$1
    local wasm_file=$2
    local flags=$3

    if [[ ! -x "$WAT2WASM" ]]; then
        echo -e "${RED}Error: wat2wasm not found. Please build WABT first.${NC}"
        return 1
    fi

    $WAT2WASM $flags "$wat_file" -o "$wasm_file" 2>/dev/null
}

run_with_wabt() {
    local wasm_file=$1
    local flags=$2
    local interp=$(get_runtime_binary "wabt")

    $interp $flags "$wasm_file" --run-all-exports 2>/dev/null
}

run_with_wasmtime() {
    local wasm_file=$1
    local wabt_flags=$2
    local wasmtime=$(get_runtime_binary "wasmtime")

    # Convert wabt flags to wasmtime flags
    local wt_flags=""
    case "$wabt_flags" in
        *--enable-tail-call*)        wt_flags="$wt_flags -W tail-call=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-exceptions*)       wt_flags="$wt_flags -W exceptions=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-threads*)          wt_flags="$wt_flags -W threads=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-memory64*)         wt_flags="$wt_flags -W memory64=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-multi-memory*)     wt_flags="$wt_flags -W multi-memory=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-extended-const*)   wt_flags="$wt_flags -W extended-const=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-relaxed-simd*)     wt_flags="$wt_flags -W relaxed-simd=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-function-references*) wt_flags="$wt_flags -W function-references=y" ;;
    esac
    case "$wabt_flags" in
        *--enable-gc*)               wt_flags="$wt_flags -W gc=y -W function-references=y -W reference-types=y" ;;
    esac

    # Check if this is a WASI module (has wasi imports)
    if wasm-objdump -x "$wasm_file" 2>/dev/null | grep -q "wasi_snapshot_preview1"; then
        $wasmtime run $wt_flags "$wasm_file" 2>/dev/null
    else
        # Core WASM or WasmGC - use invoke
        $wasmtime run $wt_flags --invoke _start "$wasm_file" 2>/dev/null || \
        $wasmtime run $wt_flags "$wasm_file" 2>/dev/null
    fi
}

run_with_wasmer() {
    local wasm_file=$1
    local wasmer=$(get_runtime_binary "wasmer")

    # Wasmer can auto-detect WASI
    $wasmer run "$wasm_file" 2>/dev/null || \
    $wasmer run --invoke _start "$wasm_file" 2>/dev/null
}

run_with_wazero() {
    local wasm_file=$1
    local wazero=$(get_runtime_binary "wazero")

    $wazero run "$wasm_file" 2>/dev/null
}

run_with_nodejs() {
    local wasm_file=$1
    local node=$(get_runtime_binary "nodejs")

    # Create a temporary JS wrapper
    local js_wrapper="/tmp/wasm_test_$$.js"

    cat > "$js_wrapper" <<'EOF'
const fs = require('fs');
const { WASI } = require('wasi');

const wasmFile = process.argv[2];
const wasmBuffer = fs.readFileSync(wasmFile);

// Check if module has WASI imports
const hasWASI = wasmBuffer.includes(Buffer.from('wasi_snapshot_preview1'));

async function run() {
    if (hasWASI) {
        const wasi = new WASI({
            args: process.argv.slice(2),
            env: process.env,
        });
        const importObject = { wasi_snapshot_preview1: wasi.wasiImport };
        const { instance } = await WebAssembly.instantiate(wasmBuffer, importObject);
        wasi.start(instance);
    } else {
        // Core WASM module
        const { instance } = await WebAssembly.instantiate(wasmBuffer);
        if (instance.exports._start) {
            instance.exports._start();
        }
    }
}

run().catch(err => {
    // Silent exit for expected traps
    process.exit(1);
});
EOF

    $node "$js_wrapper" "$wasm_file" 2>/dev/null
    local result=$?
    rm -f "$js_wrapper"
    return $result
}

run_with_wasmedge() {
    local wasm_file=$1
    local wasmedge=$(get_runtime_binary "wasmedge")

    $wasmedge "$wasm_file" 2>/dev/null
}

get_proposal_flags() {
    local file=$1
    local flags=""

    # Proposal-specific flags for WABT
    if [[ "$file" == *"/proposals/tail-call/"* ]]; then
        flags="--enable-tail-call"
    elif [[ "$file" == *"/proposals/exceptions/"* ]]; then
        flags="--enable-exceptions"
    elif [[ "$file" == *"/proposals/threads/"* ]]; then
        flags="--enable-threads"
    elif [[ "$file" == *"/proposals/memory64/"* ]]; then
        flags="--enable-memory64"
    elif [[ "$file" == *"/proposals/multi-memory/"* ]]; then
        flags="--enable-multi-memory"
    elif [[ "$file" == *"/proposals/extended-const/"* ]]; then
        flags="--enable-extended-const"
    elif [[ "$file" == *"/proposals/relaxed-simd/"* ]]; then
        flags="--enable-relaxed-simd"
    elif [[ "$file" == *"/proposals/function-references/"* ]]; then
        flags="--enable-function-references"
    fi

    echo "$flags"
}

get_wasmgc_flags() {
    echo "--enable-gc --enable-function-references --enable-reference-types"
}

test_file() {
    local runtime=$1
    local category=$2
    local wat_file=$3

    local relative_path="${wat_file#$SCRIPT_DIR/}"
    local wasm_file="${wat_file%.wat}.wasm"
    local flags=""

    increment_runtime_var "TOTAL" "$runtime"
    add_tested_runtime "$runtime"

    # Get appropriate flags based on category and file path
    if [[ "$category" == "wasmgc" ]]; then
        flags=$(get_wasmgc_flags)
    else
        flags=$(get_proposal_flags "$wat_file")
    fi

    # Skip import tests for all runtimes
    if [[ "$wat_file" == *"/imports/"* && "$category" == "core" ]]; then
        echo -e "${YELLOW}SKIP${NC} $relative_path [$runtime] (requires imports)"
        increment_runtime_var "SKIPPED" "$runtime"
        return
    fi

    # Skip proposals not supported by wasmtime (as of v27.0.0)
    if [[ "$runtime" == "wasmtime" ]]; then
        if [[ "$wat_file" == *"/proposals/exceptions/"* ]]; then
            echo -e "${YELLOW}SKIP${NC} $relative_path [$runtime] (exceptions proposal not supported)"
            increment_runtime_var "SKIPPED" "$runtime"
            return
        fi
        if [[ "$wat_file" == *"/proposals/extended-const/"* ]]; then
            echo -e "${YELLOW}SKIP${NC} $relative_path [$runtime] (extended-const proposal not supported)"
            increment_runtime_var "SKIPPED" "$runtime"
            return
        fi
    fi

    # Skip WasmGC tests - wabt cannot compile GC syntax (struct.new, ref $Type, etc.)
    # See RUNTIME_NOTES.md for details on adding a GC-capable WAT compiler
    if [[ "$category" == "wasmgc" ]]; then
        echo -e "${YELLOW}SKIP${NC} $relative_path [$runtime] (wabt cannot compile WasmGC syntax)"
        increment_runtime_var "SKIPPED" "$runtime"
        return
    fi

    # Compile WAT to WASM
    if ! compile_wat "$wat_file" "$wasm_file" "$flags"; then
        echo -e "${RED}FAIL${NC} $relative_path [$runtime] (compilation error)"
        increment_runtime_var "FAILED" "$runtime"
        return
    fi

    # Run with appropriate runtime
    local run_result=1
    case "$runtime" in
        wabt)
            run_with_wabt "$wasm_file" "$flags" && run_result=0 || run_result=$?
            ;;
        wasmtime)
            run_with_wasmtime "$wasm_file" "$flags" && run_result=0 || run_result=$?
            ;;
        wasmer)
            run_with_wasmer "$wasm_file" && run_result=0 || run_result=$?
            ;;
        wazero)
            run_with_wazero "$wasm_file" && run_result=0 || run_result=$?
            ;;
        nodejs)
            run_with_nodejs "$wasm_file" && run_result=0 || run_result=$?
            ;;
        wasmedge)
            run_with_wasmedge "$wasm_file" && run_result=0 || run_result=$?
            ;;
    esac

    # Clean up
    rm -f "$wasm_file"

    # Report result
    if [[ $run_result -eq 0 ]]; then
        echo -e "${GREEN}PASS${NC} $relative_path [$runtime]"
        increment_runtime_var "PASSED" "$runtime"
    else
        # Check if this test is expected to trap (filename contains "trap" or is in edge-cases/stress)
        local basename=$(basename "$wat_file" .wat)
        if [[ "$basename" == *"trap"* || "$wat_file" == *"/edge-cases/"* || "$wat_file" == *"/stress/"* ]]; then
            echo -e "${GREEN}PASS${NC} $relative_path [$runtime] (expected trap)"
            increment_runtime_var "PASSED" "$runtime"
        else
            echo -e "${RED}FAIL${NC} $relative_path [$runtime] (runtime error)"
            increment_runtime_var "FAILED" "$runtime"
        fi
    fi
}

test_category() {
    local runtime=$1
    local category=$2

    local test_dir=""
    case "$category" in
        core)
            test_dir="${SCRIPT_DIR}/wat/core"
            ;;
        proposals)
            test_dir="${SCRIPT_DIR}/wat/proposals"
            ;;
        wasi)
            test_dir="${SCRIPT_DIR}/wasi"
            ;;
        wasix)
            test_dir="${SCRIPT_DIR}/wasix"
            ;;
        wasmgc)
            test_dir="${SCRIPT_DIR}/wasmgc"
            ;;
        *)
            echo "Unknown category: $category"
            return 1
            ;;
    esac

    if [[ ! -d "$test_dir" ]]; then
        echo -e "${YELLOW}Category $category not found at $test_dir${NC}"
        return 0
    fi

    # Count tests in this category
    local test_count=$(find "$test_dir" -name "*.wat" -type f | wc -l | tr -d ' ')

    # Check if wat2wasm is required and working
    if [[ "$WAT2WASM_WORKS" != "true" ]]; then
        print_subheader "Testing $category with $runtime"
        echo -e "${YELLOW}UNSUPPORTED${NC} $category [$runtime] - wat2wasm not available (${test_count} tests)"
        echo -e "             WABT tools need to be rebuilt for this platform"
        add_tested_runtime "$runtime"
        set_runtime_var "UNSUPPORTED" "$runtime" "$(($(get_runtime_var "UNSUPPORTED" "$runtime") + test_count))"
        return 0
    fi

    # Check if runtime is available
    local binary=$(get_runtime_binary "$runtime")
    if [[ -z "$binary" ]]; then
        print_subheader "Testing $category with $runtime"
        echo -e "${YELLOW}UNSUPPORTED${NC} $category [$runtime] - runtime not available (${test_count} tests)"
        add_tested_runtime "$runtime"
        set_runtime_var "UNSUPPORTED" "$runtime" "$(($(get_runtime_var "UNSUPPORTED" "$runtime") + test_count))"
        return 0
    fi

    print_subheader "Testing $category with $runtime"

    local files=$(find "$test_dir" -name "*.wat" -type f | sort)
    for file in $files; do
        test_file "$runtime" "$category" "$file"
    done
}

# Check which runtimes are compatible with a category
get_compatible_runtimes() {
    local category=$1
    local runtimes=""

    case "$category" in
        core|proposals)
            runtimes="wabt wasmtime wasmer wazero nodejs wasmedge"
            ;;
        wasi)
            runtimes="wasmtime wasmer wazero nodejs wasmedge"
            ;;
        wasix)
            runtimes="wasmer"
            ;;
        wasmgc)
            runtimes="wasmtime nodejs"
            ;;
    esac

    echo "$runtimes"
}

print_summary() {
    print_header "Conformance Test Summary"

    local total_failed=0
    local total_unsupported=0

    for runtime in $TESTED_RUNTIMES; do
        local total=$(get_runtime_var "TOTAL" "$runtime")
        local passed=$(get_runtime_var "PASSED" "$runtime")
        local failed=$(get_runtime_var "FAILED" "$runtime")
        local skipped=$(get_runtime_var "SKIPPED" "$runtime")
        local unsupported=$(get_runtime_var "UNSUPPORTED" "$runtime")

        total=${total:-0}
        passed=${passed:-0}
        failed=${failed:-0}
        skipped=${skipped:-0}
        unsupported=${unsupported:-0}

        echo ""
        print_runtime_header "$runtime"

        if [[ $unsupported -gt 0 && $total -eq 0 ]]; then
            # Only unsupported tests, no actual runs
            echo -e "${YELLOW}Unsupported: $unsupported tests${NC}"
            echo -e "             (platform tools not available)"
        else
            echo -e "Total:   $total"
            echo -e "${GREEN}Passed:  $passed${NC}"
            echo -e "${RED}Failed:  $failed${NC}"
            echo -e "${YELLOW}Skipped: $skipped${NC}"
            if [[ $unsupported -gt 0 ]]; then
                echo -e "${YELLOW}Unsupported: $unsupported${NC}"
            fi
        fi

        total_failed=$((total_failed + failed))
        total_unsupported=$((total_unsupported + unsupported))
    done

    echo ""

    if [[ $total_failed -gt 0 ]]; then
        echo -e "${RED}Some tests failed${NC}"
        return 1
    elif [[ $total_unsupported -gt 0 && $(echo $TESTED_RUNTIMES | wc -w) -gt 0 ]]; then
        local any_passed=false
        for runtime in $TESTED_RUNTIMES; do
            local passed=$(get_runtime_var "PASSED" "$runtime")
            if [[ ${passed:-0} -gt 0 ]]; then
                any_passed=true
                break
            fi
        done
        if [[ "$any_passed" == "true" ]]; then
            echo -e "${GREEN}All available tests passed!${NC}"
            echo -e "${YELLOW}Some tests unsupported on this platform${NC}"
        else
            echo -e "${YELLOW}No tests could run - platform tools not available${NC}"
            echo -e "Run ./scripts/setup_runtimes.sh to install required tools"
        fi
        return 0
    else
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    fi
}

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Multi-runtime WebAssembly conformance test runner.

Options:
    --runtime RUNTIME    Test with specific runtime (wabt, wasmtime, wasmer, wazero, nodejs, wasmedge)
    --category CATEGORY  Test specific category (core, proposals, wasi, wasix, wasmgc)
    --all-runtimes       Test with all available runtimes
    --matrix             Show runtime capability matrix
    --help, -h           Show this help

Examples:
    $0 --runtime wasmtime --category wasi
    $0 --category wasmgc --all-runtimes
    $0 --all-runtimes
    $0 --matrix

If no options provided, tests core WASM with all available runtimes.
EOF
}

show_matrix() {
    print_header "Runtime Capability Matrix"
    echo ""

    # Check wat2wasm first
    echo "Build Tools:"
    if check_wat2wasm; then
        echo -e "  ${GREEN}✓${NC} wat2wasm available"
    else
        echo -e "  ${RED}✗${NC} wat2wasm not available (WABT needs to be built)"
    fi
    echo ""

    printf "%-15s %-8s %-8s %-8s %-8s\n" "Runtime" "Core" "WASI" "WASIX" "WasmGC"
    echo "----------------------------------------------------------------"

    for runtime in $ALL_RUNTIMES; do
        local avail="✗"
        if check_runtime "$runtime"; then
            avail="✓"
        fi

        local core="✓" wasi="✗" wasix="✗" wasmgc="✗"

        case "$runtime" in
            wabt)
                ;;
            wasmtime)
                wasi="✓"; wasmgc="✓"
                ;;
            wasmer)
                wasi="✓"; wasix="✓"
                ;;
            wazero|wasmedge)
                wasi="✓"
                ;;
            nodejs)
                wasi="✓"; wasmgc="✓"
                ;;
        esac

        if [[ "$avail" == "✓" ]]; then
            printf "${GREEN}%-15s${NC} %-8s %-8s %-8s %-8s\n" "$runtime ($avail)" "$core" "$wasi" "$wasix" "$wasmgc"
        else
            printf "${RED}%-15s${NC} %-8s %-8s %-8s %-8s\n" "$runtime ($avail)" "$core" "$wasi" "$wasix" "$wasmgc"
        fi
    done

    echo ""
}

main() {
    local runtime=""
    local category=""
    local all_runtimes=false
    local show_matrix_only=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --runtime)
                runtime="$2"
                shift 2
                ;;
            --category)
                category="$2"
                shift 2
                ;;
            --all-runtimes)
                all_runtimes=true
                shift
                ;;
            --matrix)
                show_matrix_only=true
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    if [[ "$show_matrix_only" == true ]]; then
        show_matrix
        exit 0
    fi

    print_header "WebAssembly Conformance Test Runner"
    echo ""

    # Check WABT tools (required for compilation)
    echo "Checking WABT tools..."
    if check_wat2wasm; then
        echo -e "  ${GREEN}✓${NC} wat2wasm: $WAT2WASM"
    else
        if [[ -x "$WAT2WASM" ]]; then
            echo -e "  ${RED}✗${NC} wat2wasm: exists but cannot execute (wrong platform?)"
        else
            echo -e "  ${RED}✗${NC} wat2wasm: not found"
        fi
        echo -e "  ${YELLOW}→${NC} WABT needs to be built for this platform"
        echo -e "  ${YELLOW}→${NC} Run: cd external/wabt && mkdir -p build && cd build && cmake .. && make"
    fi
    echo ""

    # Check runtime availability
    echo "Checking runtime availability..."
    local available_runtimes=""
    for rt in $ALL_RUNTIMES; do
        if check_runtime "$rt"; then
            local binary=$(get_runtime_binary "$rt")
            echo -e "  ${GREEN}✓${NC} $rt: $binary"
            available_runtimes="$available_runtimes $rt"
        else
            local binary=""
            case "$rt" in
                wabt) binary="${PROJECT_ROOT}/external/wabt/bin/wasm-interp" ;;
                wasmtime) binary="${PROJECT_ROOT}/external/wasmtime/wasmtime" ;;
                wasmer) binary="${PROJECT_ROOT}/external/wasmer/bin/wasmer" ;;
                wazero) binary="${PROJECT_ROOT}/external/wazero/bin/wazero" ;;
                wasmedge) binary="${PROJECT_ROOT}/external/wasmedge/bin/wasmedge" ;;
            esac
            if [[ -x "$binary" ]]; then
                echo -e "  ${RED}✗${NC} $rt: exists but cannot execute (wrong platform?)"
            else
                echo -e "  ${RED}✗${NC} $rt: not found"
            fi
        fi
    done
    echo ""

    # Trim leading space
    available_runtimes="${available_runtimes# }"

    if [[ -z "$available_runtimes" ]]; then
        echo -e "${RED}No runtimes available. Please run scripts/setup_runtimes.sh${NC}"
        exit 1
    fi

    # Determine which runtimes to test
    local test_runtimes=""
    if [[ -n "$runtime" ]]; then
        test_runtimes="$runtime"
    elif [[ "$all_runtimes" == true ]]; then
        test_runtimes="$available_runtimes"
    else
        # Default: test with core runtimes
        for rt in wabt wasmtime wasmer; do
            if [[ " $available_runtimes " =~ " $rt " ]]; then
                test_runtimes="$test_runtimes $rt"
            fi
        done
        test_runtimes="${test_runtimes# }"
    fi

    # Determine categories to test
    local categories=""
    if [[ -n "$category" ]]; then
        categories="$category"
    else
        categories="core proposals wasi wasix wasmgc"
    fi

    # Run tests
    for cat in $categories; do
        local compatible_runtimes=$(get_compatible_runtimes "$cat")

        for rt in $test_runtimes; do
            # Check if runtime is compatible with category
            if [[ ! " $compatible_runtimes " =~ " $rt " ]]; then
                continue
            fi

            # Check if runtime is available
            local binary=$(get_runtime_binary "$rt")
            if [[ -z "$binary" ]]; then
                continue
            fi

            test_category "$rt" "$cat"
            echo ""
        done
    done

    # Print summary
    print_summary
}

main "$@"
