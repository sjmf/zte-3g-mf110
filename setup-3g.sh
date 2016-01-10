#!/bin/bash
cd "$(dirname "$0")"
# Set up 3g usb dongle ZTE WCDMA Technologies MSM MF110

if [ "$EUID" -ne 0 ]; then
	echo "Please run this script as root"; exit 1;
fi


apt-get update
apt-get install -y ppp usb-modeswitch wvdial


echo "Copying configuration files"
cp -v config/19d2\:0103 /etc/usb_modeswitch.d/19d2\:0103
cp -v config/ppp-wvdial /etc/ppp/peers/wvdial


# Append config into wvdial (creating if not exists)
if grep -q giffgaff /etc/wvdial.conf; then
	echo "Config for APN giffgaff already exists"
else
	echo "Appending config into /etc/wvdial.conf"
	cat config/wvdial.conf >> /etc/wvdial.conf
fi


echo "Copying 3g connect script into /opt/3g"
mkdir -p /opt/3g
cp ./run/3g.sh /opt/3g/


echo "Setting up boot scripts in /etc/rc.local"
if [[ "$(tail -n1 /etc/rc.local)" == "exit 0" ]]; 
then 
	echo "Removing exit 0 from end of /etc/rc.local"
	head -n -1 /etc/rc.local > rc.local.tmp
	mv rc.local.tmp /etc/rc.local
fi


echo "# Run 3g dongle connect script"  >> /etc/rc.local
echo "echo \"Run 3g dongle connect script\""  >> /etc/rc.local
echo "/opt/3g/3g.sh >/dev/null 2>&1 &" >> /etc/rc.local
chmod +x /etc/rc.local

echo "Done."
