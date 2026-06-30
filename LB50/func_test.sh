# # Set GCC version and flags
# export CC=gcc-5
# export CXX=g++-5
# export CFLAGS="-fPIC -fno-pie -DFORTIFY_SOURCE=2 -fno-omit-frame-pointer -g -Wno-error -O0"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="$CFLAGS"

# # Navigate to source
cd /out/binutils-gdb

# # Clean deeply (optional but safer)
# find . -name config.cache -delete
# make distclean || true
# autoreconf -fvi
# # Configure and rebuild everything
# ./configure --disable-werror
# make clean
# make -j$(nproc) > /dev/null
# echo "Build complete."

# Run binutils-only regression tests (includes readelf)
make -C binutils check
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi