#!/bin/bash
# === CONFIG ===
PATCH_DIR="/out/patches"
VULN_FILE="/src/libxslt/libxslt/transform.c"
TOP_DIR="/src/libxslt"
COMPILE_DIR="/src/libxslt"
RESULTS_DIR="/out/results"
FUNC_START=980
FUNC_END=1137
BACKUP_FILE="${VULN_FILE}.bak"

LOG_DIR_COMP="$RESULTS_DIR/compile_test"
LOG_DIR_FUNC="$RESULTS_DIR/func_test"
LOG_DIR_SEC="$RESULTS_DIR/sec_test"
RESULT_FILE="$RESULTS_DIR/results.txt"

total_file=0
total_compile=0      
total_func=0        
total_sec=0         
total_func_sec=0     

cd $COMPILE_DIR
echo "[*] Resetting to original vulnerable version..."
pushd "$TOP_DIR" >/dev/null  
git reset --hard
git clean -fd
popd >/dev/null     

mkdir -p "$LOG_DIR_SEC"
mkdir -p "$LOG_DIR_FUNC"
mkdir -p "$LOG_DIR_COMP"

# Backup original
cp "$VULN_FILE" "$BACKUP_FILE"
# Clear previous result file
echo "" > "$RESULT_FILE"

# Track results
declare -A compile_results
declare -A func_results
declare -A sec_results

# Apply patch and run tests
apply_patch() {
    local patch_file="$1"
    local patch_name
    patch_name=$(basename "$patch_file" .patch)
    # patch_name=${patch_name%.patch}

    echo "[+] Applying patch: $patch_name"

    # Replace function
    sed -i "${FUNC_START},${FUNC_END}d" "$VULN_FILE"
    tail -c1 "$patch_file" | read -r last_char || echo >> "$patch_file"
    sed -i "$((FUNC_START - 1)) r $patch_file" "$VULN_FILE"

    # Run compile.sh
    bash /out/compile.sh > "${LOG_DIR_COMP}/${patch_name}.log" 2>&1
    echo "[+] compile.sh output saved to: ${LOG_DIR_COMP}/${patch_name}.log"

    # Run func_test.sh
    bash /out/func_test.sh > "${LOG_DIR_FUNC}/${patch_name}.log" 2>&1
    echo "[+] func_test.sh output saved to: ${LOG_DIR_FUNC}/${patch_name}.log"

    # Run sec_test.sh
    bash /out/sec_test.sh > "${LOG_DIR_SEC}/${patch_name}.log" 2>&1
    echo "[+] sec_test.sh output saved to: ${LOG_DIR_SEC}/${patch_name}.log"

    # Save results from last lines
    compile_results["$patch_name"]="$(tail -n 1 "${LOG_DIR_COMP}/${patch_name}.log" | tr '[:upper:]' '[:lower:]')"
    func_results["$patch_name"]="$(tail -n 1 "${LOG_DIR_FUNC}/${patch_name}.log" | tr '[:upper:]' '[:lower:]')"
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
    printf "%-20s %-20s %-20s %-20s\n" "patch" "compile" "func" "sec"
    printf "%-20s %-20s %-20s %-20s\n" "------" "-------" "-----" "----"

    for patch in "${!compile_results[@]}"; do
        ((total_file++))
        c=${compile_results[$patch]}
        f=${func_results[$patch]}
        s=${sec_results[$patch]}
        [[ $c == "fail" ]] && { f="fail"; s="fail"; }

        [[ "$c" == "pass" ]] && ((total_compile++))
        [[ "$f" == "pass" ]] && ((total_func++))
        [[ "$s" == "pass" ]] && ((total_sec++))
        if [[ "$f" == "pass" && "$s" == "pass" ]]; then
            ((total_func_sec++))
            cp "$PATCH_DIR/$patch.patch" passed_patches/
        fi

        printf "%-20s %-20s %-20s %-20s\n" "$patch" "$c" "$f" "$s"
    done

    echo ""
    echo "total patches:"
    echo "total: $total_file"
    echo "compile: $total_compile"
    echo "func: $total_func"
    echo "sec: $total_sec"
    echo "func&sec: $total_func_sec"
} > "$RESULT_FILE"

echo "[+] Summary written to: $RESULT_FILE"
echo "[+] Copied func&sec passed patches to: passed_patches/"