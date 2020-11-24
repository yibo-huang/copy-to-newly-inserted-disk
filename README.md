# Autocpy

a bash script used for copying chos/build/kernel8.img to a new plugin device.

Detail:
    This script will automatically detect the newest plugin device and ask if it is your target device.
    Then it detect if this device has been mounted. If not, this script will mount it for you.
    Then it will copy kernel8.img to the mountpoint of target device.
    It won't make any changes to your computer.