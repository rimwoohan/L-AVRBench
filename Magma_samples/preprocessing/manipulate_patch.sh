#!/bin/bash
#set -e
echo $(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FILE_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# echo $FILE_PATH
CANARY_LIST="$FILE_PATH/canary-list"
# echo $CANARY_LIST
# exit 1
if [[ ! -f $CANARY_LIST ]]; then
    echo "Cannot find canary-list."
    exit 1
fi

CANARY_DIR="$FILE_PATH/canary"

while IFS= read -r CANARY_NAME || [[ -n "$CANARY_NAME" ]]; do
    if [[ -n "$CANARY_NAME" ]]; then
        pushd "$FILE_PATH/model_patches/$CANARY_NAME" > /dev/null
        # echo "`pwd`"
            for patch_file in "`pwd`"/*; do
                # echo "$patch_file"
                grep -n "//c" "$patch_file" | while read -r line; do
                    # echo "$patch_file"
                    line_number=$(echo "$line" | cut -d: -f1)
                    line_content=$(echo "$line" | cut -d: -f2-)
                    echo "$line_content"

                    if [[ ! "$line_content" =~ ^[+-] ]]; then
                        next_line_number=$((line_number + 1))
                        next_line_content=$(sed -n "${next_line_number}p" "$patch_file")
                        echo "$next_line_content"
                        if [[ "$next_line_content" =~ ^[+] ]]; then
                            next_line_number=$((next_line_number + 1))
                            next_line_content=$(sed -n "${next_line_number}p" "$patch_file")
                            while [[ "$next_line_content" =~ ^[+-] ]]; do
                                next_line_number=$((next_line_number + 1))
                                next_line_content=$(sed -n "${next_line_number}p" "$patch_file")
                            done
                            # after context should be changed to the first line of canary
                            canary_line=$(grep -n "CANARY_DETECT" "$CANARY_DIR/$CANARY_NAME.canary" | cut -d: -f2-)
                            canary_line="${canary_line#?}"
                            echo "$canary_line"
                            mapfile -t patch_file_lines < "$patch_file"
                            patch_file_lines[$((next_line_number - 1))]="$canary_line"
                            printf "%s\n" "${patch_file_lines[@]}" > $patch_file
                            #sed -i.bak "${next_line_number}s|.*|${canary_line}|g" $patch_file
                        elif [[ "$next_line_content" =~ ^[-] ]]; then
                            ## before context //c should be changed to the last line of canary
                            canary_line=$(grep -n "CANARY_DETECT" "$CANARY_DIR/$CANARY_NAME.canary" | cut -d: -f2-)
                            canary_line="${canary_line#?}"
                            echo "$canary_line"
                            mapfile -t patch_file_lines < "$patch_file"
                            patch_file_lines[$((line_number - 1))]="$canary_line"
                            printf "%s\n" "${patch_file_lines[@]}" > $patch_file
                            #sed -i.bak "${line_number}s|.*|${canary_line}|g" $patch_file
                        fi
                    fi
                done
            done
        popd > /dev/null
    fi
done < "$CANARY_LIST"

