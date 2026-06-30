export ASAN_OPTIONS=detect_leaks=0

cd ImageMagick
make distclean
CC=gcc CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)
./utilities/magick identify ../oom-ReadWPGImage \
  > ../sec_test/out.log 2>&1

if grep "WARNING: AddressSanitizer" ../sec_test/out.log | grep -q "failed"; then
    echo "FAIL"
else
    echo "PASS"
fi