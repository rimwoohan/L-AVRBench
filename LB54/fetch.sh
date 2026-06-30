mkdir -p dev-patch

git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
git checkout 0ba058579f332b3060d8470a04ddd3fbf305be61^
git format-patch -1 0ba058579f332b3060d8470a04ddd3fbf305be61
cp *.patch ../dev-patch/fix.patch
