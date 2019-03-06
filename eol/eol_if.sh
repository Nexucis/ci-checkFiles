#!/bin/bash

result=0;
if [[ -n $(/usr/bin/dos2unix --info=c "$1") ]] ; then
    echo "the file $1 have DOS EOL"
    result=1;
fi

exit ${result}
