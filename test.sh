#!/bin/bash

make clean
make
INPUT=("2+2;" "2-1;" "2*qwea;" "2+2 mod 2-1+(111*3/2)*asd;" "3+asda1* 123123123; 2+2;" "1div 1;")
for i in "${INPUT[@]}"; do
    echo '==============================='
    echo input: 
    echo $i
    echo output:
    echo $i | ./out
    code=$?
    echo code: $code
    if [ $code -ne  0 ]; then
        echo "ERROR IN TEST!"
        exit 1
    fi
done
exit 0