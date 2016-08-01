#!/bin/bash

## Master function script
## this script will call all functions in this directory
## Network functions will be loaded in "../functions/functionsNetworkProfileSelection"

## This is just a master test script it wont be used for something :-)
. ./functions/masterVariables.sh

# Import other functions
. ./functions/functionGetFedoraSource.sh
. ./functions/functionRpiBoot.sh
. ./functions/functionUnmount.sh
. ./functions/functionRootCheck.sh
. ./functions/functionCopyImage.sh
. ./functions/functionCreateMounts.sh
. ./functions/functionCreateFS.sh
. ./functions/functionCreatePartitions.sh
. ./functions/functionSetVars.sh
