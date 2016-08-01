#!/bin/bash

function functionRootCheck {
# Check if script is running as root...
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}
