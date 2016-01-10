# ZTE 3g mf110 on a Pi
Scripts to run and connect at boot the zte mf110 3g dongle on a Raspberry Pi

Putting these scripts here to set up my 3g dongle with rpis, for when I need to repeat this.

There appears to be some problem with usb_modeswitch detecting this dongle properly. Rather than spend time investigating properly I've hacked in a script to run from /etc/rc.local to run a reconnector script on boot, in a loop.

It should cope properly with the dongle being unplugged, etc; though there'll be a 20 second delay by default as the script  `$RETRY` variable is set to that.

## DANGER!
This script will clobber any config files it finds. This suits me just fine- it might not suit you.

