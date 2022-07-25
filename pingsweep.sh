#!/bin/bash

# Display Help and Exit
if [ "$1" == "-h" ]
then
	figlet Pingsweep.sh
	echo "Pingsweep is a simple script to scan /24 networks."
	echo "Syntax: ./ipsweep.sh xxx.xxx.xxx"
	exit
fi

if [ "$1" == "" ]
then
	figlet Pingsweep.sh
    echo "You forgot an IP address!"
    echo "Syntax: ./ipsweep.sh 192.168.1"

else
    for ip in `seq 1 254`; do
    ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
    done
fi
