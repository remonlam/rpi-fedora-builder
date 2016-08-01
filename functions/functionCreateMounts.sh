#!/bin/bash

function functionCreateMounts () {
  mkdir -p /mnt/fedora
  mkdir -p /mnt/sdcard
  mount /dev/${_device}${_mmc}2 /mnt/sdcard
  mkdir -p /mnt/sdcard/boot
  mount /dev/${_device}${_mmc}1 /mnt/sdcard/boot
  mount -o offset=${_offset} /root/temp/Fedora-${_variant}-armhfp-24-1.2-sda.raw /mnt/fedora

}
