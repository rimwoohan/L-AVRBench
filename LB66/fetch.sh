mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout 4e378ea8fb99e869768f34e900105e8c769adfcd^
git format-patch -1 4e378ea8fb99e869768f34e900105e8c769adfcd
cp *.patch ../dev-patch/fix.patch