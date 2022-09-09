#!/bin/sh
## Setup variables to avoid input for timezone settings
export DEBIAN_FRONTEND=noninteractive TZ=Europe/Paris

# Fix issue with libGL on Windows
export LIBGL_ALWAYS_INDIRECT=1

apt-get update && apt-get upgrade -y

# Get packages for frama-c
apt-get install -y autoconf graphviz libgmp-dev pkg-config libexpat1-dev \
									 libgnomecanvas2-dev libgtk2.0-dev libgtksourceview2.0-dev zlib1g-dev
apt-get install -y opam
echo "#################"
echo "mkdir /opt/opam"
mkdir /opt/opam
echo "#################"
echo "opam init --root=/opt/opam --yes"
opam init --root=/opt/opam --yes
echo "#################"
echo "eval $(opam env --root=/opt/opam)"
eval $(opam env --root=/opt/opam)
export OPAMROOT=/opt/opam
echo "#################"
echo "opam install -y frama-c"
opam install -y frama-c
echo "#################"
echo "opam install -y frama-c-metacsl"
opam install -y frama-c-metacsl
echo "#################"
echo "opam install -y why3-ide"
opam install -y why3-ide

# Compute the name of the architecture
arch=`uname -m`; if [ $arch = "x86_64" ]; then arch="amd64"; elif [ $arch = "aarch64" ]; then arch="arm64"; fi

# Copy the built executables to the host
echo "#################"
echo "tar zcf /workspace/opt-opam_$arch.tgz /opt/opam"
tar zcf /workspace/binaries/opt-opam_$arch.tgz /opt/opam
