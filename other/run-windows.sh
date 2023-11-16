#!/bin/bash

EXTRA_ARGS=""

LSUSB_REGEX="Bus ([0-9]+) Device ([0-9]+)"

add_device() {
	LSUSB_OUTPUT=$(lsusb | grep "$1")

	if [[ $LSUSB_OUTPUT =~ $LSUSB_REGEX ]]; then
		BUS=${BASH_REMATCH[1]}
		DEVICE=${BASH_REMATCH[2]}

		echo "Adding device: $1 (${BUS}:${DEVICE})"

		sudo chown $USER:$(id -gn $USER) /dev/bus/usb/${BUS}/${DEVICE}

		EXTRA_ARGS="$EXTRA_ARGS -device usb-host,hostbus=${BUS},hostaddr=${DEVICE}"
	fi
}

if [[ $@ == *"cam"* ]]; then
	add_device "HD Pro Webcam"
fi

if [[ $@ == *"mic"* ]]; then
	add_device "Yeti Nano"
fi

if [[ $EXTRA_ARGS != "" ]]; then
	echo "Extra args:$EXTRA_ARGS"
	echo ""
	read -n 1 -p "Press any key to continue..."
	echo ""
fi

quickemu --vm windows-11.conf --display spice --extra_args "$EXTRA_ARGS"
