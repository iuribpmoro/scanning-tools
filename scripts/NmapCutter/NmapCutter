#!/bin/bash

if [ "$1" == "" ]
then
    printBanner
	echo "Usage: $0 scanResultsFile"
	echo "Example: $0 ./results"
    
    echo -e "\n"

    echo "Obs.: Testado apenas para quick scans!"

    echo -e "\n"
else
    target=$1

    cat $target | grep -v "PORT" | cut -d " " -f1 | cut -d "/" -f1 > cutterTempFile

    sed -z 's/\n/,/g;s/,$/\n/' cutterTempFile | tee cutterResults

    rm cutterTempFile

fi
