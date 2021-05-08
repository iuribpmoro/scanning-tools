#!/bin/bash

printBanner () {
    echo -e "\n"
    echo "███████╗██╗   ██╗██╗     ██╗     ███╗   ██╗███╗   ███╗ █████╗ ██████╗ "
    echo "██╔════╝██║   ██║██║     ██║     ████╗  ██║████╗ ████║██╔══██╗██╔══██╗"
    echo "█████╗  ██║   ██║██║     ██║     ██╔██╗ ██║██╔████╔██║███████║██████╔╝"
    echo "██╔══╝  ██║   ██║██║     ██║     ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝ "
    echo "██║     ╚██████╔╝███████╗███████╗██║ ╚████║██║ ╚═╝ ██║██║  ██║██║     "
    echo "╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     "
    echo -e "\n"
}

networkScan () {

    target=$1

    network=`echo $target | cut -d "/" -f1`
    mask=`echo $target | cut -d "/" -f2`

    printBanner

    mkdir $network
    
    echo -e "\n"
    echo "--------- RUNNING PING SWEEP ON THE $target NETWORK ---------"

    nmap -sn -PE $target | grep report | cut -d ' ' -f5 > $network/hosts

    echo "Hosts identificados:"
    cat $network/hosts

    echo -e "\n"
    echo "--------- RUNNING PORT SCAN ON THE HOSTS ---------"

    for host in $(cat $network/hosts)
    do
        mkdir $network/$host
        
        echo "Open ports on host $host:"

        nmap -T4 -p- -Pn $host 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > $network/$host/openPorts
        cat $network/$host/openPorts

        echo "Running full analysis of the ports..."
    	nmap -A -Pn -p $(tr '\n' , < $network/$host/openPorts) $host > $network/$host/scanResult 2> /dev/null

        wait
        
        echo "Scan on host $host finished!"
        echo -e "\n"

    done

    echo "Scan completed successfully!"
}

hostScan () {
    
    target=$1

    printBanner

    mkdir $target
    
    echo -e "\n"
    echo "--------- RUNNING PORT SCAN ON THE HOST ---------"
        
    echo "Open ports on host $target:"

    nmap -T4 -p- -Pn $target 2> /dev/null | grep 'open\|closed\|filtered\|unfiltered' | grep -v ':' | grep -v 'All' | cut -d ' ' -f1 | cut -d '/' -f1 > $target/openPorts
    cat $target/openPorts

    echo "Running full analysis of the ports..."
    nmap -A -Pn -p $(tr '\n' , < $target/openPorts) $target > $target/scanResult 2> /dev/null

    wait
    
    echo "Scan on host $target completed!"


    echo "Scan completed successfully!"
}

if [ "$1" == "" -o "$2" == "" ]
then
    printBanner
	echo "Usage: $0 <MODE> <NETWORK/MASK>"
	echo "Example: $0 network 192.168.0.0/24"
    echo -e "\n"

    echo "Available Modes: "
    echo -e "\thost - scans a specific host"
    echo -e "\tnetwork - scans all hosts found in a network"

    echo -e "\n"
else
    target=$2

    if [ "$1" == "host" ]
    then
        
        hostScan $target

    elif [ "$1" == "network" ]
    then

        networkScan $target

    fi

fi