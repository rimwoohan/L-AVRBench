export ASAN_OPTIONS=detect_leaks=0

cd ImageMagick
make distclean
CC=gcc CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)
./utilities/magick identify ../memory_exhaustion_in_ReadDCMImage