cd binutils-gdb
# make distclean

LOG="../out.log"

# # Define compiler and flags
# CC=gcc-5
# CXX=g++-5
# export CFLAGS="-fsanitize=address -g -O1 -fno-omit-frame-pointer"
# export CXXFLAGS="$CFLAGS"
# export LDFLAGS="-fsanitize=address"

# # Clean old configuration and regenerate
# find . -name config.cache -delete
# make distclean || true
# autoreconf -fvi

# # Configure with custom compilers
# ./configure --disable-werror --enable-targets=all

# # Build using inline flags
# make clean
# make -j$(nproc) #CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" > /dev/null
cd binutils-gdb
make distclean

# Define compiler and flags
CC=gcc
CXX=g++
export CFLAGS="-fsanitize=address -g -O1 -fno-omit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fsanitize=address -ldl"
export ASAN_OPTIONS="detect_leaks=0"

# Clean old configuration and regenerate
find . -name config.cache -delete
make distclean || true
autoreconf -fvi

# Configure with custom compilers
./configure --disable-werror

# Build using inline flags
mkdir -p noasan
make clean
make -j$(nproc) CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS"

# Run the target binary and check for ASan errors
./binutils/readelf -a ../00258-binutils-readelf-heapoverflow2-byte_get_little_endian > "$LOG" 2>&1
if grep -q "ERROR: AddressSanitizer" "$LOG"; then
    echo "FAIL"
    exit 1
else
    echo "PASS"
    exit 0
fi
