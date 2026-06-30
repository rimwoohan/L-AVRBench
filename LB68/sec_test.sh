export CC=clang
export CXX=clang++
export CFLAGS="-fsanitize=address -g -O1"
export CXXFLAGS="-fsanitize=address -g -O1"
export LDFLAGS="-fsanitize=address"

cd ImageMagick
make distclean
./configure --disable-shared --enable-hdri --with-png --with-jpeg --with-tiff
make clean
make -j$(nproc)
./ImageMagick/utilities/magick identify -verbose use-after-free-ReadMNGImage \
  > ../sec_test/out.log 2>&1

if grep "ERROR: AddressSanitizer" ../sec_test/out.log; then
    echo "FAIL"
else
    echo "PASS"
fi