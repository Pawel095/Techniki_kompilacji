#!/bin/bash

make clean
make
INPUT=("2+2;" "2-1;" "2+22-11*(123/222);" "3+asda1 div 123123123;")
for i in "${INPUT[@]}"; do
    echo '==============================='
    echo input: 
    echo $i
    echo output:
    printf "%s" $i | ./out
    code=$?
    echo code: $code
    if [ $code -ne  0 ]; then
        echo "ERROR IN TEST!"
        exit 1
    fi
done
exit 0