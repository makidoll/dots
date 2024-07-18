#!/bin/bash

if [[ $1 == "stop" ]]; then
	sudo virsh shutdown win11
	exit 0
fi

echo "Starting virtual machine..."
sudo virsh start win11

echo "Starting looking glass..."

sudo chmod 777 /dev/shm/looking-glass

setsid nohup looking-glass-client \
	-p 5900 -m KEY_RIGHTSHIFT -K 144 -S -F \
	2>/dev/null 1>/dev/null &
