#!/bin/bash

function  functionRpiBoot {
wget -P $firm_location -c https://github.com/raspberrypi/firmware/archive/master.zip
unzip -f -d $firm_location -qq $firm_location/master.zip
cp -rf $firm_location/firmware-master/boot/* $sd_mount_locaton/boot/
cp -rf $firm_location/firmware-master/modules/* $sd_mount_locaton/lib/modules/
cp -rf $git_location/sources/boot/config.txt $sd_mount_locaton/boot/
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait" > $sd_mount_locaton/boot/cmdline.txt
}
