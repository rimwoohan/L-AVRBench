#!/bin/bash
set -e

WORKDIR="/out"
FUZZER="$WORKDIR/afl_asan"
TARGET="$WORKDIR"
OUT="$WORKDIR/bin"

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address,undefined"
export CXXFLAGS="-g -O0 -fsanitize=address,undefined"
export LDFLAGS="-g -fsanitize=address,undefined"

export LIBS="$FUZZER/out/afl_driver.o $FUZZER/out/afl-llvm-rt.o -lstdc++ -lz -llzma"

cd "$WORKDIR/libxml2"
echo "[+] Cleaning previous build..."
make clean || true

echo "[+] Building libxml2 with ASAN/UBSAN instrumentation..."
make CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" -j$(nproc)

mkdir -p "$OUT"
cp "$WORKDIR/libxml2/xmllint" "$OUT/"

echo "[+] Building fuzzers..."
echo "OUT directory: $OUT"

for fuzzer in libxml2_xml_read_memory_fuzzer; do
  echo "[+] Compiling $fuzzer..."
  $CXX $CXXFLAGS -std=c++11 -I"$WORKDIR/libxml2/include" \
    "$TARGET/src/$fuzzer.cc" -o "$OUT/$fuzzer" \
    "$WORKDIR/libxml2/.libs/libxml2.a" $LDFLAGS $LIBS

  if [ -f "$OUT/$fuzzer" ]; then
    echo "[✓] $OUT/$fuzzer created successfully."
  else
    echo "[✗] Failed to create $OUT/$fuzzer"
    exit 1
  fi
done

cp "$TARGET"/src/*.dict "$TARGET"/src/*.options "$OUT/"

echo "[+] Fuzzer binaries created:"
ls -lh "$OUT"

mkdir -p "$WORKDIR/test_result/security"

echo "[+] Running fuzzer on PoC input..."
ASAN_OPTIONS=redzone=128 "$OUT/xmllint" --memory --valid "$WORKDIR/poc" > "$WORKDIR/sec_test_output.log" 2>&1 || echo "[!] xmllint crashed"

if grep "ERROR: AddressSanitizer:" "$WORKDIR/sec_test_output.log"; then
    echo "FAIL"
else
    echo "PASS"
fi

rm -rf "$OUT"