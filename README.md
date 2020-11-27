# Autocpy
## DESCRIPTION:
* a bash script used for copying file to a new plugin device.

## USAGE:
* e.g  ./imgcpy.sh build/kernel8.img


## DETAIL:
* This script will automatically detect the newest plugin device and ask if it is your target device.
* Then it detect if this device has been mounted. If not, this script will mount it for you.
* Then it will copy the file you specified to the mountpoint of target device.
* It won't make any changes to your computer.

## WARNING
* Because /dev/sda* is usually our computer's hard disk. So in case of copying file to the wrong place, this script will do a secrity check for you.