# Navigate to source
cd binutils-gdb
# Set GCC version
CC=gcc
CXX=g++

# Set compiler flags
export CFLAGS="-fPIC -fno-pie -DFORTIFY_SOURCE=2 -fno-omit-frame-pointer -g -Wno-error -O0"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="$CFLAGS"



# Clean previous configuration and build artifacts
find . -name config.cache -delete
make distclean || true
autoreconf -fvi

# rm -rf build
# mkdir build
# cd build

# Configure build system
./configure --disable-werror

# Clean and rebuild with flags
make clean
make -j$(nproc) CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi
# make -C binutils check
