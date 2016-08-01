#!/bin/bash

function functionGetFedoraSource () {
  echo "Downloading Fedora image"
  mkdir -p /root/temp/
  wget -c download.fedoraproject.org/pub/fedora/linux/releases/24/Spins/armhfp/images/Fedora-${_variant}-armhfp-24-1.2-sda.raw.xz
  xz -kd $firm_location/Fedora-${_variant}-armhfp-24-1.2-sda.raw.xz
  _offset=$(partx /root/temp/Fedora-${_variant}-armhfp-24-1.2-sda.raw | tail -n 1 | awk '{print $2}')
  _offset=$((_offset*512))
}
