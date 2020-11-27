#!/bin/bash
# Description:
#       This script is used for automatically copying file to a newly inserted device.
#
# Usage:
#       ./imgcpy.sh build/kernel8.img
# 
# Attention:
#       If you launch this script before plugin your device, this script may copy file to /dev/sda*,
#       which is obviously a wrong behaviour. (The script will do the secrity check for you, so don't worry)

loop_flag=1
while [ "${loop_flag}" != "0" ]
do
        if [ $# = 0 ]; then
                echo "Please specify the file(dir) you want to copy:"
                read file_path
        elif [ $# = 1 ]; then
                file_path=$1
        else
                echo "[ERROR] Wrong arguments number. Abort."
                exit 0
        fi
        
        while [ 1 ]
        do
                file_path=$PWD/$file_path
                test -e ${file_path} && loop_flag=0 && break
                echo "[ERROR] File(dir) "$file_path" does not exist, please retry:"
                read file_path
        done
done

echo "The file(dir) to be copied is "$file_path

loop_flag=1
while [ "${loop_flag}" != "0" ]
do
        # Detecting your new plugins...
        sd_path=$(ls --sort=time /dev/sd* | awk '{print $1}' | sed -n '1p')
        test ! $? -eq 0 && echo "[ERROR] Detect device failed" && exit 0

        test ! -e ${sd_path} && echo "[ERROR] "$sd_path" does not exist." && exit 0

        echo "Detected the newest device "$sd_path

        echo "Is "$sd_path" your target device ? (y/n, default is yes)"
        read res
        while [ 1 ]
        do
                if [ "${res}" = "y" ] || [ "${res}" = "Y" ] || [ "${res}" = "yes" ] || [ "${res}" = "" ]; then
                        # Security check.
                        echo "${sd_path}" | grep '/dev/sda.*' > /dev/null 2>&1 && echo "[CAUTION] Are you sure "${sd_path}" is your target device ? Please retry." && exit 0
                        echo "Continue..."
                        loop_flag=0
                        break
                elif [ "${res}" = "n" ] || [ "${res}" = "N" ] || [ "${res}" = "no" ]; then
                        echo "Please plugin your device and try again."
                        echo "Type enter to retry..."
                        read plugin
                        break
                else
                        echo "Please type (y/n, default is yes), try again."
                        read res
                fi
        done
done

sd_mount_point=$(mount -l | grep ${sd_path} | awk '{print $3}' | sed -n '1p')
test ! $? -eq 0 && echo "[ERROR] Detect mount point failed" && exit 0

# if os doesn't mount it automatically...
# then create a new folder ~/sdcard_tmp123456789 and mount it.
if [ ! ${sd_mount_point} ]; then
        # use a unique folder name
        sd_mount_point=/home/$USER/sdcard_tmp64613167asdfdqewr

        # create mount point if it doesn't exit.
        test ! -d ${sd_mount_point} && mkdir ${sd_mount_point}

        sudo mount ${sd_path} ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] mount failed" && exit 0
        echo "The mount point of "$sd_path" is "${sd_mount_point}" (mounted by script automatically)"

        sudo cp -R $file_path ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] cp failed" && exit 0

        sync
        echo "Finish copying Kernel8.img to "$sd_path

        # umount device
        sudo umount ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] umount failed" && exit 0

        # delete mount point
        sudo rm -r ${sd_mount_point}
        test ! $? -eq 0 && echo "[ERROR] rm failed" && exit 0
        
        exit 0
fi

# if os mount it automatically...
echo "The mount point of SD card is "${sd_mount_point}" (mounted by OS automatically)"

cp -R $file_path ${sd_mount_point}
test ! $? -eq 0 && echo "[ERROR] mount failed" && exit 0

sync

echo "Finished copying Kernel8.img to "$sd_path

exit 0