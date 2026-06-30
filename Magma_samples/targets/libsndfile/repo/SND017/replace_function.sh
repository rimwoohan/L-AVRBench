#!/bin/bash
set -e

### ex) ./replace_function.sh /home/host/001.patch

Z=$(find . -name "*.vuln" -print -quit)

if [ -n "$Z" ]; then
    cp $Z ${Z%.vuln}
else
    echo "File with name .vuln not found in here"
    exit 1
fi

sed -i '123,465d' ${Z%.vuln} && sed -i "122r $1" ${Z%.vuln}
