#!/bin/bash
result=0

for var in "$@"; do
    find ./ -type f -name "$var" -print0 | xargs -0 eol_if
    if [ $? != 0 ]; then
        result=1
    fi
done

exit ${result}
