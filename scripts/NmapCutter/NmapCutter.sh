#!/bin/bash

# ----------------------------- Color definition ----------------------------- #

black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`

randomColorNumber=$((0 + $RANDOM % 7))
randomColor=`tput setaf ${randomColorNumber}`

if [ "$1" == "" ]
then
    echo -e "${bold}\nUsage: ${reset}./NmapCutter.sh scanResultsFile"
    echo -e "${bold}Example: ${reset}./NmapCutter.sh ./results"
    
    echo -e "\n"

    echo "${bold}Obs.: ${reset}Testado apenas para quick scans!"

    echo -e "\n"
else
    target=$1

    cat $target | grep -v "PORT" | cut -d " " -f1 | cut -d "/" -f1 > cutterTempFile

    sed -z 's/\n/,/g;s/,$/\n/' cutterTempFile | tee cutterResults

    rm cutterTempFile

fi
