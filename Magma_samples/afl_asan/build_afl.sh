#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y make build-essential clang llvm git wget curl daemontools

git clone --no-checkout https://github.com/google/AFL.git
git -C "`pwd`/AFL" checkout 61037103ae3722c8060ff7082994836a794f978e
cp "`pwd`/src/afl_driver.cpp" "`pwd`/AFL/afl_driver.cpp"

mkdir -p "`pwd`/out"
OUT="`pwd`/out"

cd "`pwd`/AFL"
CC=clang make -j $(nproc)
CC=clang make -j $(nproc) -C llvm_mode

#"./afl-clang-fast++" -g -O0 -fsanitize=address -std=c++11 -c "afl_driver.cpp" -fPIC -o "$OUT/afl_driver.o"
"clang++" -g -O0 -fsanitize=address -std=c++11 -c "afl_driver.cpp" -fPIC -o "$OUT/afl_driver.o"
cp "$OUT/../AFL/afl-llvm-rt.o" "$OUT"
