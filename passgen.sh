#!/bin/bash

# Display Help and Exit
if [ "$1" == "-h" ]
then
	figlet PassGen
	echo "PassGen (Passowrd Generator) is a simple script to create strong passwords."
	echo "Syntax: ./passgen.sh"
	exit
fi

figlet PassGen
echo "Enter the desired password length"
read pass_length

for p in $(seq 1); do
	password=$(openssl rand -base64 48 | cut -c1-$pass_length)
done

echo "Your password is $password."