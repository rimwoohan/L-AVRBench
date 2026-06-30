#!/bin/bash
set -e

sudo apt-get update && \
    sudo apt-get install -y git make autoconf automake libtool

mkdir -p "`pwd`/repo/repo/openssl"

git clone https://github.com/openssl/openssl.git "`pwd`/repo/repo/openssl"
git -C "`pwd`/repo/repo/openssl" checkout 5db7b99914c9a13798e9d7783a02e68ae7e411d8
cp -r "`pwd`/repo/repo/openssl/test/smime-certs" "`pwd`/repo/repo/smime-certs"
cp -r "`pwd`/repo/repo/openssl/test/certs" "`pwd`/repo/repo/certs"

git -C "`pwd`/repo/repo/openssl" checkout 3bd5319b5d0df9ecf05c8baba2c401ad8e3ba130

rm -rf "`pwd`/repo/repo/openssl/test/smime-certs"
rm -rf "`pwd`/repo/repo/openssl/test/certs"
mv "`pwd`/repo/repo/smime-certs" "`pwd`/repo/repo/openssl/test/smime-certs" 
mv "`pwd`/repo/repo/certs" "`pwd`/repo/repo/openssl/test/certs" 

cp "`pwd`/src/abilist.txt" "`pwd`/repo/repo/openssl/abilist.txt"
cd "`pwd`/repo/repo/"
"./build.sh"
