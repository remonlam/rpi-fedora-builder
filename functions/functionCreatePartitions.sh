#!/bin/bash

function functionCreatePartitions () {
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
