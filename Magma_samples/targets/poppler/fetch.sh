#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf automake libtool pkg-config cmake \
        zlib1g-dev libjpeg-dev libopenjp2-7-dev libpng-dev libcairo2-dev \
        libtiff-dev liblcms2-dev libboost-dev libgtk-3-dev libgdk-pixbuf2.0-dev
        
sudo apt-get install libnss3 libnss3-dev libcurl4-openssl-dev poppler-data


mkdir -p "`pwd`/repo/repo/poppler"
mkdir -p "`pwd`/repo/repo/freetype2"

git clone --no-checkout https://gitlab.freedesktop.org/poppler/poppler.git \
    "`pwd`/repo/repo/poppler"
git -C "`pwd`/repo/repo/poppler" checkout 1d23101ccebe14261c6afc024ea14f29d209e760

git clone https://gitlab.freedesktop.org/poppler/test.git "`pwd`/repo/repo/test"

git clone --no-checkout https://gitlab.freedesktop.org/freetype/freetype.git \
    "`pwd`/repo/repo/freetype2"
git -C "`pwd`/repo/repo/freetype2" checkout 50d0033f7ee600c5f5831b28877353769d1f7d48

cd "`pwd`/repo/repo"
"./build.sh"
