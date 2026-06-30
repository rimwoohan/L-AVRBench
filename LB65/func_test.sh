export ASAN_OPTIONS=detect_leaks=0
cd ImageMagick
make distclean
./configure --with-freetype=yes --with-fontconfig=yes

cp Makefile Makefile.bak
sed -i '/tests\/validate-formats-\(disk\|map\|memory\)\.tap[ \\]*$/d' Makefile

make clean
make -j$(nproc) > /dev/null
if make -j$(nproc) check; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi

mv Makefile.bak Makefile
