#!/bin/bash
for ((i = 0; i < 5; i++)); do
        read -p "Enter ip of site server: " ip
        ping -c 3 $ip &> /dev/null
        if [ $? -eq 0 ]; then
                echo "Ok"
                break
        fi
        if [ $i -eq 4 ]; then
                echo "Too many attempts"
                exit 2
        fi
        echo "Wrong ip to connect to site server, please try again"
done
sed -i -E 's/([0-9]{1,3}[\.]){3}[0-9]{1,3}/'$ip'/' ansible/prometheus.yml

read -p 'Enter username (by default no changes in inventori.ini): ' username
if [ ! -z $username ]; then
	sed -i 's/vboxuser/'$username'/' inventory.ini
fi

sed -i 's|/home/a/br/|'$HOME/.ssh/'|' ansible/inventory.ini

echo 'Do you want to make new virtual machine? (default:no)'
read -p 'y/n: ' answer
if [[ $answer = y ]] || [[ $answer = Y ]]; then
	cd terraform/
	terraform apply -auto-approve
	vm_ip=$(terraform output -raw vm_ip)
	lb_ip=$(terraform output -raw lb_ip)
	cd ../ansible
	sed -i 's/vboxuser/'ubuntu'/' inventory.ini
	sed -i -E 's/([0-9]{1,3}[\.]){3}[0-9]{1,3}/'$vm_ip'/' inventory.ini
	ansible-playbook -i inventory.ini runner.yml -b -K -e $1
elif [[ $answer = n ]] || [[ $answer = N ]] || [[ -z $answer ]]; then
	echo "Skipping terraform deploy"
	cd ansible/
	read -p 'Enter username (by default no changes in inventori.ini): ' username
	if [ ! -z $username ]; then
		sed -i 's/=b/'=$username'/' inventory.ini
	fi
		read -p 'Enter server ip (by default no changes in inventori.ini ip): ' vm_ip
	if [ -z $vm_ip ]; then
		ansible-playbook -i inventory.ini runner.yml -b -K -e $1
	else
		sed -i -E 's/([0-9]{1,3}[\.]){3}[0-9]{1,3}/'$vm_ip'/' inventory.ini
		ansible-playbook -i inventory.ini runner.yml -b -K -e $1
	fi
fi
