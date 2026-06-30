# mkdir -p dev-patch

git clone https://gitlab.gnome.org/GNOME/libxml2.git
cd libxml2
git checkout 92b9e8c^
# git format-patch -1 92b9e8c
# cp *.patch ../dev-patch/fix.patch

