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

tf=$(basename "$(pwd)")
proj_home=$(pwd)
mkdir -p "$proj_home/repo/$1/test_result/compile"
mkdir -p "$proj_home/repo/$1/test_result/functionality"

pushd "`pwd`/repo/repo" > /dev/null
    "./build4func.sh"
    if [ $? -ne 0 ]; then
        echo "ERROR : There is some error in building project. Try again."
        exit 22
    fi
popd > /dev/null

while read -r patch; do

    if [ $VUL_ADV == 1 ] && [ -f "`pwd`/repo/$1/canary.patch" ]; then
        cp "$patch" "$patch.canary"
        grep -v "CANARY_DETECT" $patch > $patch
    fi

    pushd "`pwd`/repo/$1" > /dev/null
        "./replace_function.sh" $patch
        if [ $? -ne 0 ]; then
            echo "ERROR : There is some error in replacing the function."
            mv "$patch.canary" "$patch"
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
            mv "$patch.canary" "$patch"
            exit 1
        fi
    done < <(find "`pwd`/repo/$1" -name "*.vuln")
    
    patch_name=${patch##*/}
    pushd "`pwd`/repo/repo"
        "./make4func.sh"
        if [ $? -eq 0 ]; then
            echo "PASS" > "$proj_home/repo/$1/test_result/compile/${patch_name%.patch}" 2>&1
            pushd "`pwd`/$tf" > /dev/null
                make -j test
                if [ $? -eq 0 ]; then
                    echo "PASS" > "$proj_home/repo/$1/test_result/functionality/${patch_name%.patch}" 2>&1
                else
                    echo "FAIL" > "$proj_home/repo/$1/test_result/functionality/${patch_name%.patch}" 2>&1
                fi
            popd > /dev/null
        else
            echo "FAIL" > "$proj_home/repo/$1/test_result/compile/${patch_name%.patch}" 2>&1
        fi
    popd

    if [ $VUL_ADV == 1 ] && [ -f "`pwd`/repo/$1/canary.patch" ]; then
        mv "$patch.canary" "$patch"
    fi

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
