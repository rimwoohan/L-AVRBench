cd tiff-4.0.1
make distclean
CC=clang CFLAGS="-fsanitize=address -g -O0" ./configure
make clean
make -j$(nproc)
./tools/bmp2tiff ../libtiff-poc.bmp out.tif  # adjust binary name as per repo
