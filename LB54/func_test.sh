export CC=clang
export CXX=clang++

cd FFmpeg
make distclean
./configure --cc=clang --cxx=clang++

make clean
make -j$(nproc)
if make -j$(nproc) check > /dev/null; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi