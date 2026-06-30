#!/bin/bash
set -e

# mkdir -p dev-patch

git clone https://gitlab.gnome.org/GNOME/libxml2.git
cd libxml2
git checkout 8c8753a^
# git format-patch -1 8c8753a
# cp *.patch ../dev-patch/fix.patch

