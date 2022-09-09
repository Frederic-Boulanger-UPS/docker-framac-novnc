FROM fredblgr/ubuntu-novnc:20.04

ARG arch
ARG bindir

# Avoid prompts for time zone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y autoconf graphviz libgmp-dev pkg-config libexpat1-dev \
                       libgnomecanvas2-dev libgtk2.0-dev libgtksourceview2.0-dev \
                       zlib1g-dev

RUN apt-get install -y swi-prolog

COPY $bindir/opt-opam_$arch.tgz /opt-opam.tgz
RUN cd /; tar zxf opt-opam.tgz && rm opt-opam.tgz
RUN OPAMROOT=/opt/opam; export OPAMROOT; \
		OPAM_SWITCH_PREFIX='/opt/opam/default'; export OPAM_SWITCH_PREFIX; \
		CAML_LD_LIBRARY_PATH='/opt/opam/default/lib/stublibs:Updated by package ocaml'; export CAML_LD_LIBRARY_PATH; \
		OCAML_TOPLEVEL_PATH='/opt/opam/default/lib/toplevel'; export OCAML_TOPLEVEL_PATH; \
		MANPATH=':/opt/opam/default/man'; export MANPATH; \
		PATH='/opt/opam/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'; export PATH;

# Install Z3
COPY $bindir/z3_$arch /usr/local/bin/z3
RUN chmod a+x /usr/local/bin/z3

# Install E prover
COPY $bindir/eprover_$arch /usr/local/bin/eprover
RUN chmod a+x /usr/local/bin/eprover

# Install Souffle
COPY $bindir/souffle_$arch.tgz /usr/local/souffle.tgz
RUN cd /usr/local ; tar zxf souffle.tgz; rm souffle.tgz; cd /
RUN apt-get install -y mcpp

## Setup for opam environment in .profile
RUN echo ". /opt/opam/opam-init/variables.sh" >> /root/.profile
RUN echo ". /opt/opam/opam-init/variables.sh" >> /root/.bashrc

# Configure Why3
RUN . /opt/opam/opam-init/variables.sh \
    && mkdir -p /home/ubuntu \
    && why3 config detect \
    && mv /home/ubuntu/.why3.conf /root/

# Clean up
RUN apt-get autoremove && apt-get autoclean
