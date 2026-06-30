export CC=clang
export CXX=clang++

cd FFmpeg
make distclean
./configure --cc=clang --cxx=clang++

make clean
if make -j$(nproc) > /dev/null; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi