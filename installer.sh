#!/bin/bash

## Import Variables & Functions from external sources
. ./functions/masterVariables.sh
. ./functions/masterFunctions.sh

## Function execution
functionRootCheck
functionSetVars
functionGetFedoraSource
functionCreatePartitions
functionCreateFS
functionCreateMounts
functionCopyImage
functionRpiBoot
#install_firmware
functionUnmount
