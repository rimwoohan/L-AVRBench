sudo apt-get update
sudo apt-get install -y \
    clang g++ libstdc++6 libstdc++-6-dev \
    git make autoconf automake libtool

export CC="clang"
export CXX="clang++"
export AS="as"

export CFLAGS="-g -O0 -fsanitize=address"
export CXXFLAGS="-g -O0 -fsanitize=address"
export LDFLAGS="-fsanitize=address"

unset LIBS
unset LDLIBS

cd openssl

CONFIGURE_FLAGS=""
if [[ $CFLAGS = *sanitize=memory* ]]; then
  CONFIGURE_FLAGS="no-asm"
fi
# the config script supports env var LDLIBS instead of LIBS
export LDLIBS="$LIBS"

./config \
    --debug \
    no-shared \
    enable-tls1_3 enable-ssl-trace enable-rc5 enable-md2 \
    enable-ec_nistp_64_gcc_128 enable-ssl3 enable-dynamic-engine \
    enable-ssl3-method enable-nextprotoneg enable-weak-ssl-ciphers \
    $CONFIGURE_FLAGS \
    -fno-sanitize=alignment

make -j$(nproc) clean
make -j$(nproc) LDCMD="$CXX $CXXFLAGS"
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi



