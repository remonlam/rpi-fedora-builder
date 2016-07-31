#! /bin/bash

### VARIABLES
firm_location=/root/temp
git_location=/root/rpi-fedora-builder
sd_mount_locaton=/mnt/sdcard/


### FUNCTIONS
function setup_vars () {
  if [ -z "$_variant" ]; then
    echo -n "Enter a variant (KDE LXDE Mate Minimal SoaS Xfce):"
    read _variant
  fi
  if [ -z "$_device" ]; then
    echo -n "Enter the location of your sdcard (mmcblk0 sdb):"
    read _device
  fi
  if [[ "$_device" =~ ^"mmcblk".* ]]; then
    _mmc="p"
  else
    _mmc=""
  fi
  case "$_variant" in
        "KDE" | "LXDE" | "Mate" | "Minimal" | "SoaS" | "Xfce" )
                echo "Done with setup, grab a cup of tea"
            ;;
        *)
                echo "Please type the variant name exactly as presented to you" 1>&2
                unset _variant
                setup_vars
            ;;
  esac
}

function get_fedora () {
  echo "Downloading Fedora image"
  mkdir -p /root/temp/
  cd /root/temp
  wget -c download.fedoraproject.org/pub/fedora/linux/releases/24/Spins/armhfp/images/Fedora-${_variant}-armhfp-24-1.2-sda.raw.xz
  #git clone --depth=1 git://github.com/p3ck/rpi2-fedora # moved to RPI-Firmware
  #git clone --depth=1 git://github.com/p3ck/firmware # moved to RPI-Firmware
  xz -kd Fedora-${_variant}-armhfp-24-1.2-sda.raw.xz
  _offset=$(partx /root/temp/Fedora-${_variant}-armhfp-24-1.2-sda.raw | tail -n 1 | awk '{print $2}')
  _offset=$((_offset*512))
}

#
function set_rpi_boot {
#curl -L -o raspberry-firmware.zip https://github.com/raspberrypi/firmware/archive/master.zip #move it to git
cd /mnt/sdcard/boot
wget -P $firm_location -c https://github.com/raspberrypi/firmware/archive/master.zip
unzip -d$firm_location -qq $firm_location/master.zip

cp -r $firm_location/firmware-master/boot/* $sd_mount_locaton/boot/
cp -rf $firm_location/firmware-master/modules/* $sd_mount_locaton/lib/modules/
cp -r $git_location/config.txt $sd_mount_locaton/boot/
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait" > $sd_mount_locaton/boot/cmdline.txt

}
#

function setup_device () {
  cat <<- EOF | fdisk /dev/${_device}
o
n
p
1

+500M
t
c
n
p
2


w
EOF
  return
}

function format_parts () {
  mkfs.vfat /dev/${_device}${_mmc}1
  echo 'y' | mkfs.ext4 /dev/${_device}${_mmc}2
}

function mount_dirs () {
  mkdir -p /mnt/fedora
  mkdir -p /mnt/sdcard
  mount /dev/${_device}${_mmc}2 /mnt/sdcard
  mkdir -p /mnt/sdcard/boot
  mount /dev/${_device}${_mmc}1 /mnt/sdcard/boot
  mount -o offset=${_offset} /root/temp/Fedora-${_variant}-armhfp-24-1.2-sda.raw /mnt/fedora

}

function setup_fedora () {
  echo "Putting Fedora23 on your device"
  cp -a /mnt/fedora/* /mnt/sdcard/
  echo "UUID=`lsblk -rno UUID /dev/${_device}${_mmc}2`  / ext4    defaults,noatime 0 0" > /mnt/sdcard/etc/fstab
  echo "UUID=`lsblk -rno UUID /dev/${_device}${_mmc}1`  /boot vfat    defaults,noatime 0 0" >> /mnt/sdcard/etc/fstab
}

function install_firmware () {
  echo "Installing RPi2 kernel and bootloader"
  cd /mnt/sdcard/boot
  tar -xzf /root/temp/rpi2-fedora/boot.tgz .
  cd /root/temp
  cp -r /root/temp/firmware/modules/4.0.9-v7+/ /mnt/sdcard/lib/modules/
  cp -r /root/temp/firmware/opt/vc/ /mnt/sdcard/opt/
  curl -L --output /mnt/sdcard/usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && sudo chmod +x /mnt/sdcard/usr/bin/rpi-update
  echo "bcm2708.bcm2835_mmc=1 dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait nortc" > /mnt/sdcard/boot/cmdline.txt
  rm -rf /mnt/sdcard/boot/{grub,grub2,extlinux}
}

function unmount_card () {
  sync
  umount /mnt/sdcard/boot
  umount /mnt/sdcard
  sync
  umount /mnt/fedora
  echo "You're ready to pull out that card and boot into some Fedora glory"
  echo "Don't forget your keyboard!"
  echo "If you want to delete all temporary files,"
  echo "run ./Rpi2-Fedora23 --cleanup"
  echo ""
  echo "I suggest doing this AFTER you have Fedora working"
  echo "(Saves you time and bandwidth from downloading all over again)"
}

### Begin doing stuff
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# For those who cannot be bothered to wait for a menu
while [[ "$1" =~ ^-{1,2}.* ]]; do
  case "$1" in
        "-v"|"--variant")
                _variant="$2"
                shift 2
            ;;
        "-c"|"--cleanup")
                echo "Removing all temporary files"
                rm -f /root/temp/*.raw
                rm -rf /mnt/fedora
                rm -rf /mnt/sdcard
                echo -n "Do you want to remove the downloaded fedora image as well? (y/n):"
                read -n 1 _clobber
                if [[ "$_clobber" == 'y' ]]; then
                  rm -rf /root/temp
                fi
                exit 1
            ;;
        "-d"|"--device")
                _device="$2"
                if [[ "$_device" =~ ^"mmcblk".* ]]; then
                  _mmc="p"
                else
                  _mmc=""
                fi
                shift 2
            ;;
        *)
                echo "These are not the flags you're looking for!" 1>&2
                exit 1
            ;;
  esac
done

### RUN FUNCTIONS
setup_vars
get_fedora
setup_device
format_parts
mount_dirs
setup_fedora
set_rpi_boot
#install_firmware
#unmount_card
