cd tiff-4.0.1
make distclean
./configure
make clean
make -j$(nproc)
make -j$(nproc) check
if [ $? -eq 0 ]; then
    echo "PASS" 
else
    echo "FAIL" 
fi