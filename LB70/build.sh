
git submodule init
git submodule update
autoreconf -fi
./configure --with-oniguruma=builtin
make -j$(nproc)
$CC $CFLAGS -c tests/jq_fuzz_parse.c     -I./src -o ./jq_fuzz_parse.o
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./jq_fuzz_parse.o     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_parse -I./src
$CC $CFLAGS -c tests/jq_fuzz_compile.c     -I./src -o ./jq_fuzz_compile.o
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./jq_fuzz_compile.o     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_compile -I./src
$CC $CFLAGS -c tests/jq_fuzz_load_file.c     -I./src -o ./jq_fuzz_load_file.o
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./jq_fuzz_load_file.o     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_load_file -I./src
$CC $CFLAGS -c tests/jq_fuzz_parse_extended.c     -I./src -o ./jq_fuzz_parse_extended.o
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./jq_fuzz_parse_extended.o     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_parse_extended -I./src
$CC $CFLAGS -c tests/jq_fuzz_parse_stream.c     -I./src -o ./jq_fuzz_parse_stream.o
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./jq_fuzz_parse_stream.o     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_parse_stream -I./src
$CXX $CXXFLAGS $LIB_FUZZING_ENGINE ./tests/jq_fuzz_execute.cpp     -I./src     ./.libs/libjq.a ./modules/oniguruma/src/.libs/libonig.a     -o $OUT/jq_fuzz_execute -I./src
mkdir -p $SRC/seeds
find . -name "*.jq" -exec cp {} $SRC/seeds/ \;
zip -rj $OUT/jq_fuzz_execute_seed_corpus.zip $SRC/seeds/
cp $SRC/jq.dict $OUT/jq_fuzz_execute.dict
