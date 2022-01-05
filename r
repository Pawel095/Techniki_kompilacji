#!/bin/bash

make clean > /dev/null
make -j 4
INPUT=`find ./tests/ -xtype f`
for i in "${INPUT[@]}"; do
    echo '==============================='
    echo call: 
    echo ./out $i
    out=`./out $i`
    code=$?
    echo output:
    echo $out
    echo code: $code
    if [ $code -ne  0 ]; then
        echo "ERROR IN TEST!"
        exit 1
    fi
done
make clean
make headers
exit 0