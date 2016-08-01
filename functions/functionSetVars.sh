#!/bin/bash

function functionSetVars () {
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
