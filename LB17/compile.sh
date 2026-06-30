cd libtiff
make distclean
./configure
make clean
make -j$(nproc)
if [ $? -eq 0 ]; then
    echo "PASS" 
else
    echo "FAIL" 
fi