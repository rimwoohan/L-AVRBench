#!/bin/bash

# Set correct automake path
export PATH="/out/repo/CVE-2025-32415/automake-1.16.5-install/bin:$PATH"

cd libxml2 || exit 1

# Run autogen and setup
./autogen.sh
automake --add-missing

# Set build flags
CFLAGS="-g -O0"
CONFIG_OPTIONS="--with-modules --enable-shared --disable-static --without-threads --without-lzma --without-python"

# Configure
./configure CC="clang" CXX="clang++" CFLAGS="${CFLAGS}" ${CONFIG_OPTIONS}

# Clean and rebuild
make clean
make -j"$(nproc)"

# Fix any file ownership issues from previous sudo use
sudo chown -R "$USER:$USER" ./

# Run functional check
make -j"$(nproc)" check
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi
