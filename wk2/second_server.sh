#!/bin/bash

sed -i 's|/home/a/br/|'$HOME/.ssh/'|' ansible/inventory.ini
echo 'Do you want to make new virtual machine? (default:no)'
read -p 'y/n: ' answer
if [[ $answer = y ]] || [[ $answer = Y ]]; then
	cd terraform/
	terraform apply -auto-approve
	vm_ip=$(terraform output -raw gitlab_ip)
	cd ../ansible
	sed -i 's/vboxuser/'ubuntu'/' inventory.ini
	sed -i -E 's/([0-9]{1,3}[\.]){3}[0-9]{1,3}/'$vm_ip'/' inventory.ini
	sleep 10
	ansible-playbook -i inventory.ini deploy.yml -b
elif [[ $answer = n ]] || [[ $answer = N ]] || [[ -z $answer ]]; then
	echo "Skipping terraform deploy"
	cd ansible/
	read -p 'Enter username (by default no changes in inventori.ini): ' username
	if [ ! -z $username ]; then
		sed -i 's/=ubuntu/'=$username'/' inventory.ini
	fi
		read -p 'Enter server ip (by default no changes in inventori.ini ip): ' vm_ip
	if [ -z $vm_ip ]; then
		ansible-playbook -i inventory.ini deploy.yml -b
	else
		sed -i -E 's/([0-9]{1,3}[\.]){3}[0-9]{1,3}/'$vm_ip'/' inventory.ini
		ansible-playbook -i inventory.ini deploy.yml -b
	fi
fi

#for ((i = 0; i < 5; i++)) do
#	echo 'Do you want to make new virtual machine? (default:no)'
#	read -p 'y/n: ' answer
#	if [[ $answer = y ]] || [[ $answer = Y ]]; then
#		cd terraform/
#		terraform apply -auto-approve
#		vm_ip=$(terraform output -raw vm_ip)
#		lb_ip=$(terraform output -raw lb_ip)
#		cd ../ansible
#		sed -i 's/vboxuser/'ubuntu'/' inventory.ini
#		sed -i 's/192.168.0.103/'$vm_ip'/' inventory.ini
#		ansible-playbook -i inventory.ini runner.yml -b -K -e "$1"
#	elif [[ $answer = n ]] || [[ $answer = N ]] || [[ -z $answer ]]; then
#		echo "Skipping terraform deploy"
#		cd ansible/
#		read -p 'Enter username (by default no changes in inventori.ini): ' username
#		if [ ! -z $username ]; then
#                        sed -i 's/=b/'=$username'/' inventory.ini
#                fi
#		read -p 'Enter server ip (by default no changes in inventori.ini ip): ' vm_ip
#		if [ -z $vm_ip ]; then
#			ansible-playbook -i inventory.ini runner.yml -b -K
#		else
#			sed -i 's/192.168.0.103/'$vm_ip'/' inventory.ini
#			ansible-playbook -i inventory.ini runner.yml -b -K
#		fi
#        fi
#        if [ $i -eq 4 ]; then
#                echo "Too many attempts"
#                exit 2
#        fi
#
#        echo "Wrong input, please try again"
#done
