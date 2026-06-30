export PATH="/out/repo/CVE-2025-32415/automake-1.16.5-install/bin:$PATH"

cd libxml2

./autogen.sh
automake --add-missing

CFLAGS="-g -O0"
CONFIG_OPTIONS="--with-modules --enable-shared --disable-static --without-threads --without-lzma --without-python"

./configure CC="clang" CXX="clang++" CFLAGS="${CFLAGS}" ${CONFIG_OPTIONS}

make clean
make -j$(nproc)
if [ $? -eq 0 ]; then
    echo "PASS" 
else
    echo "FAIL" 
fi
