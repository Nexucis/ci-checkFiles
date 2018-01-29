#!/bin/bash

result=0;
# print encoding target in lowercase
encoding_target=$(echo "${1,,}")
encoding_ascii="ascii"
encoding_utf8="utf-8"

for file in "${@:2}"; do
    encoding_result=$(uchardet "$file")
    # print encoding result in lowercase
    encoding_result=$(echo "${encoding_result,,}")

    if [[ ${encoding_result} != "${encoding_target}" ]] ; then
        # because a file encoding in ASCII will have the same bytes as a file encoding in UTF-8, we need to check this particular thing
        if [[ "${encoding_target}" == "${encoding_ascii}" || "${encoding_target}" == "${encoding_utf8}" ]]; then
            if [[ "${encoding_result}" != "${encoding_ascii}" && "${encoding_result}" != "${encoding_utf8}"  ]]; then
                echo "the file $file is not encoding in the targeting encoding file : ${encoding_target}. It is encoding in ${encoding_result}"
                result=1;
            fi
        else
            echo "the file $file is not encoding in the targeting encoding file : ${encoding_target}. It is encoding in ${encoding_result}"
            result=1;
        fi

    fi
done

exit ${result}