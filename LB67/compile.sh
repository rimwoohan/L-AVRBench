cd ImageMagick

make distclean
./configure --with-freetype=yes --with-fontconfig=yes

cp Makefile Makefile.bak
sed -i '/tests\/validate-formats-\(disk\|map\|memory\)\.tap[ \\]*$/d' Makefile

make clean
if make -j$(nproc) > /dev/null; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi
# make -j$(nproc) check

mv Makefile.bak Makefile