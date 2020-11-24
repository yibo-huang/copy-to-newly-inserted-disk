#!/bin/bash
# Program:
#       This program is used for automatically copying chcore's kernel8.img to your newest plugin device.
#       So if you launch this device before plugin your device, this script may copy img to your /dev/sda*, etc.
# History:
#       2020/11/23    bob     First release
# Usage:
#       Plug in your Device first, then launch this script.

# Detecting your new plugins...

loop_flag=1
while [ "${loop_flag}" != "0" ]
do
        sd_path=$(ls --sort=time /dev/sd* | awk '{print $1}' | sed -n '1p')
        test ! $? -eq 0 && echo "[ERROR] detecting device failed" && exit 0

        test ! -e ${sd_path} && echo "[ERROR] "$sd_path" does not exit." && exit 0

        echo "Detect the newest device name = "$sd_path

        echo "Is "$sd_path" your target device ? (y/n, default is yes)"
        read res
        while [ 1 ]
        do
                if [ "${res}" = "y" ] || [ "${res}" = "Y" ] || [ "${res}" = "yes" ] || [ "${res}" = "" ]; then
                        echo "${sd_path}" | grep '/dev/sda.*' && echo "[CAUTION] are you sure "${sd_path}" is your target device ? Please retry." && exit 0
                        # test $? -eq 0 
                        echo "Continue..."
                        loop_flag=0
                        break
                elif [ "${res}" = "n" ] || [ "${res}" = "N" ] || [ "${res}" = "no" ]; then
                        echo "Please plugin your device and try again."
                        echo "Type enter to retry..."
                        read plugin
                        break
                else
                        echo "please type (y/n, default is yes), try again."
                        read res
                fi
        done
done

sd_mount_point=$(mount -l | grep ${sd_path} | awk '{print $3}' | sed -n '1p')
test ! $? -eq 0 && echo "[ERROR] detect mount point failed" && exit 0

# if your os doesn't mount it for you automatically...
# then create a new folder ~/sdcard_tmp123456789 and mount it.
# after the full operation is done, the folder will be deleted.
if [ ! ${sd_mount_point} ]; then
        sd_mount_point=/home/$USER/sdcard_tmp64613167asdfdqewr          # unique folder name

        # create mount point if it doesn't exit
        test ! -d ${sd_mount_point} && mkdir ${sd_mount_point}

        sudo mount ${sd_path} ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] mount failed" && exit 0
        echo "The mount point of SD card is "${sd_mount_point}" (mounted by the script automatically)"
        

        sudo cp $PWD/build/kernel8.img ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] cp failed" && exit 0

        sync
        echo "Finish copying Kernel8.img to "$sd_path
        sudo umount ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] umount failed" && exit 0

        sudo rm -r ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] rm failed" && exit 0
        
        exit 0
fi

# if your os mount it for you automatically...
echo "The mount point of SD card is "${sd_mount_point}" (mounted by your system automatically)"

cp $PWD/build/kernel8.img ${sd_mount_point}
test ! $? -eq 0 && echo "[ERROR] mount failed" && exit 0

sync

echo "Finish copying Kernel8.img to "$sd_path

exit 0