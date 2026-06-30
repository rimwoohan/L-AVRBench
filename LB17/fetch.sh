# mkdir dev-patch

git clone https://github.com/vadz/libtiff.git
cd libtiff
git checkout 9657bbe3cdce4aaa90e07d50c1c70ae52da0ba6a^
# git format-patch -1 9657bbe3cdce4aaa90e07d50c1c70ae52da0ba6a
# cp *.patch ../dev-patch/fix.patch
