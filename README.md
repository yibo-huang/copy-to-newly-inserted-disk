# Autocpy
### DESCRIPTION:
* a bash script for copying file to a newly inserted device.

### USAGE:
* e.g  ./imgcpy.sh build/kernel8.img


### DETAIL:
* This script will automatically detect the latest inserted device.
* Then it detects if this device has been mounted. If not, the script will do it for you.
* Then it copies the file you specified to the mountpoint of target device.
* It won't make any changes to system.

### Note:
* Because /dev/sda* is usually our computer's hard disk. So in case of copying file to the wrong place, this script will do a secrity check for you.