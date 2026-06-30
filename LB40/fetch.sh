mkdir -p dev-patch

git clone https://github.com/openssl/openssl.git
cd openssl

# git checkout 5db7b99914c9a13798e9d7783a02e68ae7e411d8
git checkout 7bf52a6f6f0d22c3a1aba39d21aabf0c8a818ba7
cp -r test/smime-certs ../smime-certs
cp -r test/certs ../certs

git checkout bf52165bda53524a267c784696bd074111a2f178^
git format-patch -1 bf52165bda53524a267c784696bd074111a2f178
cp *.patch ../dev-patch/fix.patch

rm -rf test/smime-certs
rm -rf test/certs
cp -r ../smime-certs test/smime-certs
cp -r ../certs test/certs