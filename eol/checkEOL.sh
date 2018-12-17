#!/bin/bash
result=0

for var in "$@"; do
   files=$(find ./ -type f -name "$var" -print)
    for file in "${files[@]}"; do
        eol_if "$file"
        if [ $? != 0 ]; then
            result=1
        fi
    done
done

exit ${result}
