#!/bin/bash
export ASAN_OPTIONS=alloc_dealloc_mismatch=0:allocator_may_return_null=1:allocator_release_to_os_interval_ms=500:check_malloc_usable_size=0:detect_container_overflow=1:detect_odr_violation=0:detect_leaks=0:detect_stack_use_after_return=1:fast_unwind_on_fatal=0:handle_abort=1:handle_segv=1:handle_sigill=1:max_uar_stack_size_log=16:print_scariness=1:quarantine_size_mb=10:strict_memcmp=1:strip_path_prefix=/workspace/:symbolize=1:use_sigaltstack=1:dedup_token_length=3
export MSAN_OPTIONS=print_stats=1:strip_path_prefix=/workspace/:symbolize=1:dedup_token_length=3
export UBSAN_OPTIONS=print_stacktrace=1:print_summary=1:silence_unsigned_overflow=1:strip_path_prefix=/workspace/:symbolize=1:dedup_token_length=3
export FUZZER_ARGS="-rss_limit_mb=2560 -timeout=25"
export AFL_FUZZER_ARGS="-m none"
export FUZZING_ENGINE=libfuzzer
export SANITIZER=memory
export ARCHITECTURE=x86_64
export FUZZING_LANGUAGE=c++

# backup
OLD_CC=$CC
OLD_CFLAGS=$CFLAGS
OLD_LDFLAGS=$LDFLAGS
CXX=$CXX
CXXFLAGS=$CXXFLAGS

make clean
make distclean

# Step 0: Make sure environment is clean
if ! compile > /dev/null; then
    echo ""
    echo "FAIL"
    exit 1
fi

# Step 1: Setup clean build directory
pushd "$SRC" > /dev/null || { echo "FAIL"; exit 1; }

rm -rf graphicsmagick-clean
cp -r graphicsmagick graphicsmagick-clean || { echo "FAIL"; exit 1; }
cd graphicsmagick-clean 

make distclean 
unset CC CFLAGS LDFLAGS
export CXX=clang++
export CXXFLAGS="-stdlib=libstdc++"

# Step 4: Configure
if ! ./configure --prefix="$WORK" --disable-openmp --with-jpeg; then
    echo "FAIL"
    popd > /dev/null
    exit 1
fi

# Step 5: Build
if ! make -j"$(nproc)"; then
    echo "FAIL"
    popd > /dev/null
    exit 1
fi
popd > /dev/null

# Step 6: Restore environment
export CC="$OLD_CC"
export CFLAGS="$OLD_CFLAGS"
export LDFLAGS="$OLD_LDFLAGS"

echo "PASS"
exit 0
