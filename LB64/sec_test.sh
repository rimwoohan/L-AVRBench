export ASAN_OPTIONS=detect_leaks=1

cd ImageMagick
make distclean
CC=gcc CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)
./utilities/magick identify ../mem-jng \
  > ../sec_test/out.log 2>&1

if grep "ERROR: LeakSanitizer" ../sec_test/out.log; then
    echo "FAIL"
else
    echo "PASS"
fi