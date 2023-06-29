# copy files to a newly inserted disk
### DESCRIPTION:
* A bash script for copying a file to a newly inserted device

### USAGE:
* e.g  ./imgcpy.sh build/kernel8.img

### DETAIL:
* This script will automatically detect the latest inserted device
* Then it detects if this device has been mounted. If not, it will do it for you
* Then it copies the specified file to the mountpoint of the target device
* It won't make any changes to the system

### Note:
* Because /dev/sda* is usually the hard disk. So in case of copying file to the wrong place, this script will do a secrity check
