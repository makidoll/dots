#!/bin/bash

if [[ $1 == "kill" ]]; then
	killall virtiofsd
	kill -TERM $(cat ~/quickemu/windows-11/windows-11.pid)
	exit 0
fi

echo "Starting virtual machine..."

extra_args=(
	# gpu passthrough
	-device vfio-pci,host=0000:0c:00.0,romfile=/home/maki/quickemu/files/EVGA.RTX3070.8192.210307.rom
	-device vfio-pci,host=0000:0c:00.1
	# looking glass
	-device ivshmem-plain,memdev=ivshmem,bus=pcie.0
	-object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=64M
	# virtiofs
	-chardev socket,id=char0,path=/tmp/maki/vfsd-win11.sock
	-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=Maki
	-object memory-backend-file,id=mem,size=16G,mem-path=/dev/shm,share=on
	-numa node,memdev=mem 
)

quickemu_vm=(
	"#!/usr/bin/quickemu --vm"
	guest_os="windows"
	# iso="/home/maki/quickemu/files/Win11_23H2_English_x64v2.iso"
	disk_img="/home/maki/quickemu/windows-11/disk.qcow2"
	# fixed_iso="/home/maki/quickemu/windows-11/virtio-win.iso"
	tpm="on"
	secureboot="off"
)

lsusb_regex="Bus ([0-9]+) Device ([0-9]+)"

add_device() {
	lsusb_output=$(lsusb | grep "$1")

	if [[ $lsusb_output =~ $lsusb_regex ]]; then
		bus=${BASH_REMATCH[1]}
		device=${BASH_REMATCH[2]}

		echo "Adding device: $1 (${bus}:${device})"

		sudo chown maki:maki /dev/bus/usb/${bus}/${device}

		extra_args+=(
			-device usb-host,hostbus=${bus},hostaddr=${device}
		)
	fi
}

if [[ $@ == *"cam"* ]]; then
	add_device "HD Pro Webcam"
fi

if [[ $@ == *"mic"* ]]; then
	add_device "Yeti Nano"
fi

# start virtiofs

killall -q virtiofsd

sudo mkdir -p /tmp/maki
sudo chown -R maki:maki /tmp/maki

setsid /usr/lib/virtiofsd --socket-path=/tmp/maki/vfsd-win11.sock \
	--shared-dir /home/maki &

sleep 1 # vm might start too quickly. maybe

# gpu passthrough
sudo chown -R maki:maki /dev/vfio

# looking glass
# sudo chown maki:maki /dev/shm/looking-glass
sudo chmod 777 /dev/shm/looking-glass

# start emulator

printf "%s\n" "${quickemu_vm[@]}" > /home/maki/quickemu/windows-11.conf

/usr/bin/quickemu \
	--display none \
	--extra_args "$(printf "%s " ${extra_args[@]})" \
	--vm /home/maki/quickemu/windows-11.conf
	# --vm <(echo ${quickemu_vm[@]})

setsid nohup looking-glass-client \
	-p 5930 -m KEY_RIGHTSHIFT -K 144 -S -F \
	2>/dev/null 1>/dev/null &
