mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout d9ccd8227c4c88a907cda5278408b73552cb0c07^
git format-patch -1 d9ccd8227c4c88a907cda5278408b73552cb0c07
cp *.patch ../dev-patch/fix.patch