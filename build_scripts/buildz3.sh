#!/bin/sh
## Setup variables to avoid input for timezone settings
export DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris

# Fix issue with libGL on Windows
export LIBGL_ALWAYS_INDIRECT=1

apt-get update && apt-get upgrade -y

# Get packages for building solvers
apt-get install -y x11-apps nano python3-pip wget

# Build Z3 4.8.17
wget https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.11.2.tar.gz
tar zxf z3-4.11.2.tar.gz
cd z3-z3-4.11.2
PYTHON=python3 ./configure --prefix=/usr/local
cd build
make
make install
cd ../..
rm -r z3-*

# Compute the name of the architecture
arch=`uname -m`; if [ $arch = "x86_64" ]; then arch="amd64"; elif [ $arch = "aarch64" ]; then arch="arm64"; fi

# Copy the built executables to the host
cp /usr/local/bin/z3 /workspace/binaries/z3_$arch
