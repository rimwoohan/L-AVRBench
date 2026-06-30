cd libtiff
make distclean
CC=clang CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)
./tools/tiffcrop -i ../00102-libtiff-heapoverflow-_TIFFmemcpy /tmp/foo
