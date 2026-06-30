export ASAN_OPTIONS=detect_leaks=0

cd ImageMagick
# make -j$(nproc)
if make -j$(nproc) check > /dev/null; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi