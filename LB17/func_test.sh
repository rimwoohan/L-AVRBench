cd libtiff
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