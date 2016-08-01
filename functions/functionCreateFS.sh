#!/bin/bash

function functionCreateFS () {
  mkfs.vfat /dev/${_device}${_mmc}1
  echo 'y' | mkfs.ext4 /dev/${_device}${_mmc}2
}
