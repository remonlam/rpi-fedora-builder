#!/bin/bash

function functionUnmount () {
  sync
  umount /mnt/sdcard/boot
  umount /mnt/sdcard
  sync
  umount /mnt/fedora
  sync
}
