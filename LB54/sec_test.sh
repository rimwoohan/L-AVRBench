cd FFmpeg
make distclean

# 1. Set up environment for TSAN before any build
export CC=clang
export CXX=clang++
export CFLAGS="-fsanitize=thread -g"
export CXXFLAGS="-fsanitize=thread -g -std=c++11"
export LDFLAGS="-fsanitize=thread -g"

export LD_LIBRARY_PATH=$(pwd)/libavcodec:$(pwd)/libavformat:$(pwd)/libavutil:$(pwd)/libswresample:$LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH
# 2. Clean any previous build artifacts if you already built once
  # or use `make clean` + delete config.h, config.mak if needed
# git reset --hard
# git clean -xfd
# 3. Configure with your options (same as before, no build yet)

./configure \
    --cc=clang \
    --cxx=clang++ \
    --ld="clang++ -fsanitize=thread -g -std=c++11" \
    --disable-optimizations \
    --disable-stripping \
    --disable-debug \
    --disable-doc \
    --disable-programs \
    --enable-gpl \
    --enable-avcodec \
    --enable-decoder=vp9 \
    --disable-static \
    --enable-shared \
    --enable-pthreads


# 4. Compile with TSAN instrumentation
make clean
# make -j$(nproc)
make -j$(nproc) tools/venc_data_dump
if [ $? -ne 0 ]; then
    echo "FAIL"
    exit 1
fi

# 5. Run the tool that triggers the race condition
# sleep 1
# for i in {1..10}; do
#   echo "🌀 Run $i"
#   sleep $(awk 'BEGIN{srand(); print 0.3 + rand() * 0.7}')
#   ./tools/venc_data_dump ../vp90-2-10-show-existing-frame.webm 0 1000 2 frame
# done

# TSAN_OPTIONS="log_path=../tsan.log" ./tools/venc_data_dump ../vp90-2-10-show-existing-frame.webm 0 1000 2 frame
rm -f ../sec_test_output.log
./tools/venc_data_dump ../vp90-2-10-show-existing-frame.webm 0 3000 8 frame \
    > ../sec_test_output.log 2>&1
if grep "WARNING: ThreadSanitizer:" ../sec_test_output.log; then
    echo "FAIL"
else
    echo "PASS"
fi
