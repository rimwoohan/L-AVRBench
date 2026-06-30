# mkdir dev-patch

git clone https://sourceware.org/git/binutils-gdb.git
cd binutils-gdb
git checkout 75ec1fdbb797a389e4fe4aaf2e15358a070dcc19^
# git format-patch -1 75ec1fdbb797a389e4fe4aaf2e15358a070dcc19
# cp *.patch ../dev-patch/fix.patch
