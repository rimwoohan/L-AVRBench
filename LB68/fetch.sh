mkdir -p dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout 2460f71fcdb112dacbc14e3d9b9913dec66af820^
git format-patch -1 2460f71fcdb112dacbc14e3d9b9913dec66af820
cp *.patch ../dev-patch/fix.patch
