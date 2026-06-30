#!/bin/bash
cp /tmp/poc_backup.svg /tmp/poc.svg
dd if=/dev/zero bs=1 count=1 of=/tmp/blank.png
if ! "$WORK/bin/gm" convert /tmp/poc.svg output.gif ; then
    echo "NOT COMPILE"
    exit 1
fi
if strings output.gif | grep -q "root:" ; then
    echo "FAIL"
    exit 1
else
    echo "PASS"
    exit 0
fi