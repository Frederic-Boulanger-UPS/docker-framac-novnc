#!/bin/sh
## Setup variables to avoid input for timezone settings
export DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris

# Fix issue with libGL on Windows
export LIBGL_ALWAYS_INDIRECT=1

apt-get update && apt-get upgrade -y

# Get packages for building solvers
apt-get install -y x11-apps nano python3-pip wget

# Build E prover
# Old 2.0 version at http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.0/E.tgz
wget http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.6/E.tgz
tar zxf E.tgz
cd E
./configure --prefix=/usr/local
make
make install
cd ..
rm -r E E.tgz

# Compute the name of the architecture
arch=`uname -m`; if [ $arch = "x86_64" ]; then arch="amd64"; elif [ $arch = "aarch64" ]; then arch="arm64"; fi

# Copy the built executables to the host
cp /usr/local/bin/eprover /workspace/binaries/eprover_$arch
