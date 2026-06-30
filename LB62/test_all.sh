#!/bin/bash
if [[ -x "./prepare.sh" ]]; then
    echo "[+] Found prepare.sh — running it..."
    ./prepare.sh
fi
# === CONFIG ===
PATCH_DIR="/out/patches"
VULN_FILE="/src/ImageMagick/MagickCore/image.c"
TOP_DIR="/src/ImageMagick"
RESULTS_DIR="/out/results"
FUNC_START=802
FUNC_END=921
BACKUP_FILE="${VULN_FILE}.bak"

LOG_DIR_COMP="$RESULTS_DIR/compile_test"
LOG_DIR_FUNC="$RESULTS_DIR/func_test"
LOG_DIR_SEC="$RESULTS_DIR/sec_test"
RESULT_FILE="$RESULTS_DIR/Test results.txt"

echo "[*] Resetting to original vulnerable version..."
cd "$TOP_DIR"
git reset --hard
git clean -fd
cd -

mkdir -p "$LOG_DIR_SEC" "$LOG_DIR_FUNC" "$LOG_DIR_COMP"

# Backup original
cp "$VULN_FILE" "$BACKUP_FILE"

# Clear previous result file
echo "" > "$RESULT_FILE"

# Track results
declare -A compile_results
declare -A func_results
declare -A sec_results

apply_patch() {
    local patch_file="$1"
    local patch_name
    patch_name=$(basename "$patch_file" .patch)

    echo "[+] Applying patch: $patch_name"

    # Replace function
    sed -i "${FUNC_START},${FUNC_END}d" "$VULN_FILE"
    tail -c1 "$patch_file" | read -r last_char || echo >> "$patch_file"
    sed -i "$((FUNC_START - 1)) r $patch_file" "$VULN_FILE"

    # Run compile.sh
    bash /out/compile.sh > "${LOG_DIR_COMP}/${patch_name}.log" 2>&1
    echo "[+] compile.sh output saved to: ${LOG_DIR_COMP}/${patch_name}.log"
    compile_status=$(tail -n 1 "${LOG_DIR_COMP}/${patch_name}.log" | tr '[:upper:]' '[:lower:]')
    compile_results["$patch_name"]="$compile_status"

    if [[ "$compile_status" != "pass" ]]; then
        echo "[!] Skipping tests for $patch_name due to compile failure"
        func_results["$patch_name"]="fail"
        sec_results["$patch_name"]="fail"
        cp "$BACKUP_FILE" "$VULN_FILE"
        return
    fi

    # Run func_test.sh
    bash /out/func_test.sh > "${LOG_DIR_FUNC}/${patch_name}.log" 2>&1
    echo "[+] func_test.sh output saved to: ${LOG_DIR_FUNC}/${patch_name}.log"
    func_results["$patch_name"]="$(tail -n 1 "${LOG_DIR_FUNC}/${patch_name}.log" | tr '[:upper:]' '[:lower:]')"

    # Run sec_test.sh
    bash /out/sec_test.sh > "${LOG_DIR_SEC}/${patch_name}.log" 2>&1
    echo "[+] sec_test.sh output saved to: ${LOG_DIR_SEC}/${patch_name}.log"
    sec_results["$patch_name"]="$(tail -n 1 "${LOG_DIR_SEC}/${patch_name}.log" | tr '[:upper:]' '[:lower:]')"

    # Restore original
    cp "$BACKUP_FILE" "$VULN_FILE"
}

# Run for each patch
for patch in "$PATCH_DIR"/*.patch; do
    apply_patch "$patch"
done

# Clean up
rm -f "$BACKUP_FILE"

# === Write Test Summary ===
echo "[+] Generating test result summary..."
mkdir -p passed_patches

{
    printf "%-10s %-10s %-10s %-10s\n" "patch" "compile" "func" "sec"
    printf "%-10s %-10s %-10s %-10s\n" "------" "-------" "-----" "----"

    for patch in "${!compile_results[@]}"; do
        c=${compile_results[$patch]}
        f=${func_results[$patch]}
        s=${sec_results[$patch]}

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
