mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout c1b09bbec148f6ae11d0b686fdb89ac6dc0ab14e^
git format-patch -1 c1b09bbec148f6ae11d0b686fdb89ac6dc0ab14e
cp *.patch ../dev-patch/fix.patch