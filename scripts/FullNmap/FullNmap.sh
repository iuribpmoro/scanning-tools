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

printBanner () {
    echo -e "\n${randomColor}${bold}"
    echo "███████╗██╗   ██╗██╗     ██╗     ███╗   ██╗███╗   ███╗ █████╗ ██████╗ "
    echo "██╔════╝██║   ██║██║     ██║     ████╗  ██║████╗ ████║██╔══██╗██╔══██╗"
    echo "█████╗  ██║   ██║██║     ██║     ██╔██╗ ██║██╔████╔██║███████║██████╔╝"
    echo "██╔══╝  ██║   ██║██║     ██║     ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝ "
    echo "██║     ╚██████╔╝███████╗███████╗██║ ╚████║██║ ╚═╝ ██║██║  ██║██║     "
    echo "╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     "
    echo -e "\n${reset}"
}

# -------------------------------- Ping Sweep -------------------------------- #

pingSweep () {

    target=$1
    network=$2

    echo -e "\n"
    echo "${blue}${bold}--------- RUNNING PING SWEEP ON THE $target NETWORK ---------${reset}"

    sudo nmap -sn -PE $target | grep report | cut -d ' ' -f5 > hosts

    echo "${bold}Hosts identificados:${reset}"
    cat hosts

}

networkScan () {

    target=$1

    network=`echo $target | cut -d "/" -f1`
    mask=`echo $target | cut -d "/" -f2`

    mkdir $network
    cd $network
    
    pingSweep $target $network

    for host in $(cat hosts)
    do
        hostScan $host
    done

    echo "Scan completed successfully!"
}

hostScan () {
    
    target=$1

    mkdir $target
    
    echo -e "\n${blue}${bold}--------- SCANNING TARGET $target ---------${reset}"
        
    echo -e "${bold}Open ports on host $target:${reset}"

    nmap -T4 -p- -Pn $target 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > $target/openPorts
    cat $target/openPorts

    echo -e "\n${bold}Running full analysis of the ports...${reset}"
    nmap -A -Pn -p $(tr '\n' , < $target/openPorts) $target > $target/scanResult 2> /dev/null
    cat $target/scanResult | grep http | grep 'open\|closed\|filtered\|unfiltered' | cut -d " " -f1 | cut -d "/" -f1 > $target/httpPorts
    echo -e "${green}Scan results saved on $target/scanResult ${reset}\n"
    
    echo -e "\n${green}${bold}Scan on host $target completed!${reset}"

}

if [ "$1" == "" -o "$2" == "" ]
then
    printBanner
    
	echo -e "${bold}Usage: ${reset}./Automap.sh <MODE> <NETWORK/MASK>"
	echo -e "${bold}Example: ${reset}./Automap.sh network 192.168.0.0/24"
    echo -e "\n"

    echo -e "${bold}Available Modes: ${reset}"
    echo -e "\thost: scans a specific host"
    echo -e "\tnetwork: scans all hosts found in a network"

    echo -e "\n"
else
    
    printBanner
    
    target=$2

    if [ "$1" == "host" ]
    then
        
        hostScan $target

    elif [ "$1" == "network" ]
    then

        networkScan $target

    fi

fi