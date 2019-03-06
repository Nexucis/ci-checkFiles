#!/bin/bash

result=0;
echo "Testing file: <$file> -- >$1<"
if [[ -n $(/usr/bin/dos2unix --info=c "$file") ]] ; then
    echo "the file $file have DOS EOL"
    result=1;
fi

exit ${result}
