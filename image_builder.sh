#! /bin/bash

#function install_firmware () {
#  echo "Installing RPi2 kernel and bootloader"
#  cd /mnt/sdcard/boot
#  tar -xzf /root/temp/rpi2-fedora/boot.tgz .
#  cd /root/temp
#  cp -r /root/temp/firmware/modules/4.0.9-v7+/ /mnt/sdcard/lib/modules/
#  cp -r /root/temp/firmware/opt/vc/ /mnt/sdcard/opt/
#  curl -L --output /mnt/sdcard/usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && sudo chmod +x /mnt/sdcard/usr/bin/rpi-update
#  echo "bcm2708.bcm2835_mmc=1 dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rw rootfstype=ext4 rootwait nortc" > /mnt/sdcard/boot/cmdline.txt
#  rm -rf /mnt/sdcard/boot/{grub,grub2,extlinux}
#}



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
unmount_card
