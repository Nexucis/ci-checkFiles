#!/bin/bash
result=0
encoding_check=$1

for var in "${@:2}"; do
    find ./ -type f -name "$var" -print0 | xargs -0 encoding_if ${encoding_check}
    if [ $? != 0 ]; then
        result=1
    fi
done

exit ${result}
