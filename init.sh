#!/bin/bash

base_dir=$(dirname $0)
base_dir=$(realpath $base_dir)

udev_file="/etc/udev/rules.d/85-yubikey-screen-lock.rules"
trusted_file="$base_dir/trusted"

ID_VENDOR_ID=1050
ID_MODEL_ID=0407
SCRIPT="$base_dir/yubilock.sh"

# Does the udev file exist?
if [ -f $udev_file ]; then
	echo "Udev file already exist. If you want to reinit, please remove it first."
	echo "sudo rm $udev_file"
else
	# Create the udev file
	echo -e 'SUBSYSTEM=="usb", ACTION=="remove", ENV{ID_VENDOR_ID}=="'$ID_VENDOR_ID'", ENV{ID_MODEL_ID}="'$ID_MODEL_ID'", RUN+="'$SCRIPT' enable"\nSUBSYSTEM=="usb", ACTION=="add", ENV{ID_VENDOR_ID}=="'$ID_VENDOR_ID'", ENV{ID_MODEL_ID}="'$ID_MODEL_ID'", RUN+="'$SCRIPT' disable"' | sudo tee $udev_file

	# Reload the udevadm
	sudo udevadm control --reload-rules
	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot reload udevadm!"
		exit 1
	fi
fi

# Does the trusted file exist?
if [ -f $trusted_file ]; then
	echo "Trusted file already exist. If you want to reinit, please remove it first."
	echo "rm $trusted_file"
	exit 0
else
	which ykinfo 1>/dev/null 1>/dev/null
	if [ $? -ne 0 ]; then
		echo "Please install yubikey-personalization first."
		echo "sudo aptitude install yubikey-personalization"
		echo "or"
		echo "sudo dnf install yubikey-personalization"
		echo "or"
		echo "sudo pacman -S yubikey-personalization"
		exit 0
	fi

	# Create the trusted file
	echo "$USER:$(ykinfo -q -s)" > $trusted_file
	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot create trusted file"
		exit 0
	fi
fi

