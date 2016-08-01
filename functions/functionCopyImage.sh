#!/bin/bash

function functionCopyImage () {
  echo "Putting Fedora23 on your device"
  cp -a /mnt/fedora/* /mnt/sdcard/
  echo "UUID=`lsblk -rno UUID /dev/${_device}${_mmc}2`  / ext4    defaults,noatime 0 0" > /mnt/sdcard/etc/fstab
  echo "UUID=`lsblk -rno UUID /dev/${_device}${_mmc}1`  /boot vfat    defaults,noatime 0 0" >> /mnt/sdcard/etc/fstab
}
