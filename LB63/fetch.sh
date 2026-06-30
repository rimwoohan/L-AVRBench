# mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout 94933146cb2d9d95889a385f08d5eb5f92d4e3cd^
# git format-patch -1 94933146cb2d9d95889a385f08d5eb5f92d4e3cd
# cp *.patch ../dev-patch/fix.patch