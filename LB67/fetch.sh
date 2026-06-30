# mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout f1f2089^
# git format-patch -1 f1f2089
# cp *.patch ../dev-patch/fix.patch