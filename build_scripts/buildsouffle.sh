#!/bin/sh
## Setup variables to avoid input for timezone settings
export DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris

# Fix issue with libGL on Windows
export LIBGL_ALWAYS_INDIRECT=1

apt-get update && apt-get upgrade -y

# Get packages for building solvers
apt-get install -y x11-apps nano python3-pip wget

# Build Soufflé
apt-get install -y cmake autoconf bison doxygen flex g++ \
				  				 git libffi-dev libncurses5-dev libtool libsqlite3-dev mcpp \
				  				 sqlite
wget https://github.com/souffle-lang/souffle/archive/refs/tags/2.3.tar.gz
tar zxf 2.3.tar.gz && rm 2.3.tar.gz
cd souffle-2.3
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/souffle/
cmake --build build --target install
cd ..
rm -r souffle-2.3

# Compute the name of the architecture
arch=`uname -m`; if [ $arch = "x86_64" ]; then arch="amd64"; elif [ $arch = "aarch64" ]; then arch="arm64"; fi

# Copy the built executables to the host
tar zcCf /usr/souffle /workspace/binaries/souffle_$arch.tgz .
