#!/bin/bash

# === CONFIG ===
PATCH_DIR="/out/patches"
LOG_DIR_COMP="$RESULTS_DIR/compile_test"
LOG_DIR_FUNC="$RESULTS_DIR/func_test"
LOG_DIR_SEC="$RESULTS_DIR/sec_test"
RESULT_FILE="$RESULTS_DIR/Test results.txt"

echo "[+] Generating test result summary..."
echo "" > "$RESULT_FILE"

# Collect all patch names from one of the log dirs
patches=()
for f in "$LOG_DIR_COMP"/*.log; do
    patchname=$(basename "$f" .log)
    patches+=("$patchname")
done

# Track totals
total_compile=0
total_func=0
total_sec=0
total_func_sec=0

mkdir -p passed_patches

{
    printf "%-10s %-10s %-10s %-10s\n" "patch" "compile" "func" "sec"
    printf "%-10s %-10s %-10s %-10s\n" "------" "-------" "-----" "----"

    for patch in "${patches[@]}"; do
        c=$(grep -iE 'pass|fail' "$LOG_DIR_COMP/$patch.log" | tail -n 1 | tr '[:upper:]' '[:lower:]')
        f=$(grep -iE 'pass|fail' "$LOG_DIR_FUNC/$patch.log" | tail -n 1 | tr '[:upper:]' '[:lower:]')
        s=$(grep -iE 'pass|fail' "$LOG_DIR_SEC/$patch.log"  | tail -n 1 | tr '[:upper:]' '[:lower:]')

        [[ -z "$c" ]] && echo "Missing compile result for $patch"
        [[ -z "$f" ]] && echo "Missing func result for $patch"
        [[ -z "$s" ]] && echo "Missing sec result for $patch"

        [[ "$c" == "pass" ]] && ((total_compile++))
        [[ "$f" == "pass" ]] && ((total_func++))
        [[ "$s" == "pass" ]] && ((total_sec++))
        if [[ "$f" == "pass" && "$s" == "pass" ]]; then
            ((total_func_sec++))
            cp "$PATCH_DIR/$patch.patch" passed_patches/
        fi

        printf "%-10s %-10s %-10s %-10s\n" "$patch" "$c" "$f" "$s"
    done

    echo ""
    echo "total passed patches:"
    echo "compile: $total_compile"
    echo "func: $total_func"
    echo "sec: $total_sec"
    echo "func&sec: $total_func_sec"
} > "$RESULT_FILE"

echo "[+] Summary written to: $RESULT_FILE"
echo "[+] Copied func&sec passed patches to: passed_patches/"