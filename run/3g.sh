#!/bin/bash

# Look for ZTE USB 3G with 19d2:0103
DEFAULT_VENDOR=19d2
DEFAULT_PRODUCT=0103
TARGET_VENDOR=19d2
TARGET_PRODUCT=0031

RETRY=20
while sleep $RETRY;
do
	# We don't trust usb_modeswitch as it often doesn't run by default
	# Run it manually if the device is in cdrom mode

	if lsusb | grep ${DEFAULT_VENDOR}:${DEFAULT_PRODUCT};
	then 
		echo "Switching USB mode"
		usb_modeswitch -I -W -c /etc/usb_modeswitch.d/19d2\:0103 
	fi

	echo "Waiting for modem to become available..."
	sleep 4

	if lsusb | grep ${TARGET_VENDOR}:${TARGET_PRODUCT};
	then 
		wvdial giffgaff 
	else
		echo "Device ${TARGET_VENDOR}:${TARGET_PRODUCT} not found."
	fi
	
	echo "Retrying in $RETRY seconds..."
done

