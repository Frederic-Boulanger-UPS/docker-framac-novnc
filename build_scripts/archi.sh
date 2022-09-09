#!/bin/sh

# Compute the name of the architecture
arch=`uname -m`; if [ $arch = "x86_64" ]; then arch="amd64"; elif [ $arch = "aarch64" ]; then arch="arm64"; fi

echo $arch
