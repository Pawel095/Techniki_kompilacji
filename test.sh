#!/bin/bash

make clean
make
INPUT=`find ./tests/ -xtype f`
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