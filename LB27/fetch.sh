#!/bin/bash
set -e

# mkdir -p dev-patch

git clone https://gitlab.gnome.org/GNOME/libxml2.git
cd libxml2
git checkout 487ee1d^
# git format-patch -1 487ee1d
# cp *.patch ../dev-patch/fix.patch

