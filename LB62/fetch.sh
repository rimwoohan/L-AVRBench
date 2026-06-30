# mkdir dev-patch

git clone https://github.com/ImageMagick/ImageMagick.git
cd ImageMagick
git checkout 4e6ac0e67ca157b2b96d8364fae3497b69e187bc^
# git format-patch -1 4e6ac0e67ca157b2b96d8364fae3497b69e187bc
# cp *.patch ../dev-patch/fix.patch