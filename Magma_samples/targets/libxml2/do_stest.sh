#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR : Exactly one argument must be provided." >&2
    echo "USAGE EXAMPLE : ./run.sh PNG007" >&2
    exit 1
fi

names=()

while IFS= read -r patch; do
    name=${patch##*/}
    name=${name%.patch}
    names+=("$name")
done < <(find "$(pwd)/vulnerability" -name "*.patch")

# Validity Check
if [[ ! " ${names[*]} " =~ " $1 " ]]; then
    echo "ERROR: Invalid argument. Only one of the following is allowed: ${names[*]}" >&2
    exit 1
fi

#if ! cd "$(pwd)/repo/$1" 2>/dev/null; then
#    echo "ERROR: Failed to change directory to '$(pwd)/repo/$1'." >&2
#    exit 1
#fi

while read -r patch; do
    
    if [ $VUL_ADV == 0 ] && [ -f "`pwd`/repo/$1/canary.patch" ]; then
        patch -p2 --fuzz=0 -l -b "$patch" < "`pwd`/repo/$1/canary.patch"
        if [ $? -eq 0 ]; then
            echo "canary applied successfully"
        else
            echo "Something wrong happen in canary. This error should be fixed"
            echo "canary is not inserted at $1 and $patch" >> canary_fail.txt
            mkdir -p "`pwd`/canary_failed"
            cp "$patch" "`pwd`/canary_failed"
            mv "$patch.rej" "`pwd`/canary_failed"
            continue
        fi
    fi

    pushd "`pwd`/repo/$1" > /dev/null
        "./replace_function.sh" $patch
        if [ $? -ne 0 ]; then
            echo "ERROR : There is some error in replacing the function."
            exit 22
        fi
    popd > /dev/null

    while read -r vuln_file; do
        vuln_file_name=${vuln_file##*/}
        vuln_file_name="${vuln_file_name%.vuln}"
            
        Z=$(find "`pwd`/repo/repo/$(basename "$(pwd)")" -name "$vuln_file_name" -print -quit)

        if [ -n "$Z" ]; then
            mv "${vuln_file%.vuln}" "$Z"
        else
            echo "File with name $vuln_file_name not found in repo"
            exit 1
        fi
    done < <(find "`pwd`/repo/$1" -name "*.vuln")
    
    patch_name=${patch##*/}
    pushd "`pwd`/repo/repo/"
        #echo `pwd`
        "./make.sh" $1 $patch_name
        #"./check.sh" $1 $patch_name
    popd
    pushd "`pwd`/repo/$1"
        "./security_test.sh" $patch_name
    popd

done < <(find "`pwd`/patches/$1" -name "*.patch")

while read -r backup_file; do
    original_name="${backup_file%.orig}"
    mv "$backup_file" "$original_name"
done < <(find "`pwd`/patches/$1" -name "*.orig")

while read -r orig_file; do
    orig_file_name=${orig_file##*/}
    orig_file_name="${orig_file_name%.orig}"

    Y=$(find "`pwd`/repo/repo/$(basename "$(pwd)")" -name "$orig_file_name" -print -quit)

    if [ -n "$Y" ]; then
        cp "$orig_file" "$Y"
    else
        echo "File with name $orig_file_name not found in repo"
        exit 1
    fi
done < <(find "`pwd`/repo/$1" -name "*.orig")

pushd "`pwd`/repo/$1" > /dev/null
    rm -rf "`pwd`/out"
popd > /dev/null
