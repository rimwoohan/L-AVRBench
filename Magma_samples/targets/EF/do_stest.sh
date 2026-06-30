#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR : Exactly one argument must be provided." >&2
    echo "USAGE EXAMPLE : ./do_stest.sh CVE-2016-9273" >&2
    exit 1
fi

CVE_LIST="`pwd`/cve-list"

if [[ ! -f $CVE_LIST ]]; then
    echo "Cannot find cve-list."
    exit 1
fi

names=()

while IFS= read -r CVE_NAME || [[ -n "$CVE_NAME" ]]; do
    if [[ -n "$CVE_NAME" ]]; then
        names+=("$CVE_NAME")
    fi
done < "$CVE_LIST"

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
    
    #find "`pwd`/repo/repo/" -type f -name "*.orig" | \
    #while read -r backup_file; do
    #    original_name="${backup_file%.orig}"
    #    mv "$backup_file" "$original_name"
    #done

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
            
        Z=$(find "`pwd`/repo/$1/$1" -name "$vuln_file_name" -print -quit)

        if [ -n "$Z" ]; then
            mv "${vuln_file%.vuln}" "$Z"
        else
            echo "File with name $vuln_file_name not found in repo"
            exit 1
        fi
    done < <(find "`pwd`/repo/$1" -name "*.vuln")
    
    #patch -p1 -b -d "`pwd`/repo/repo/$(basename "$(pwd)")" < "$patch"
    # UNUSED : EF does not need canary, but this snippet does not affect to test.
    if [ -f "`pwd`/repo/$1/canary.patch" ]; then
        patch -p1 -b -d "`pwd`/repo/repo/$(basename "$(pwd)")" < "`pwd`/repo/$1/canary.patch"
        if [ $? -eq 0 ]; then
            echo "canary applied successfully"
        else
            echo "Something wrong happen in canary. This error should be fixed"
            exit 2
        fi
    fi

    patch_name=${patch##*/}
    pushd "`pwd`/repo/$1"
        #echo `pwd`
        "./make.sh" $1 $patch_name
    popd
    pushd "`pwd`/repo/$1"
        "./security_test.sh" $patch_name
    popd

done < <(find "`pwd`/patches/$1" -name "*.patch")

while read -r vulnerable_file; do
    vulnerable_file_name=${vulnerable_file##*/}
    vulnerable_file_name="${vulnerable_file_name%.vuln}"

    Y=$(find "`pwd`/repo/$1/$1" -name "$vulnerable_file_name" -print -quit)

    if [ -n "$Y" ]; then
        cp "$vulnerable_file" "$Y"
    else
        echo "File with name $vulnerable_file_name not found in repo"
        exit 1
    fi
done < <(find "`pwd`/repo/$1" -name "*.vuln")

pushd "`pwd`/repo/$1" > /dev/null
    rm -rf "`pwd`/out"
popd > /dev/null
